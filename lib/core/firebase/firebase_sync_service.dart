import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../../dataconnect_generated/generated.dart';
import '../database/database_helper.dart';
import '../logger/app_logger.dart';

const _tag = 'SyncService';

/// Scans the local SQLite tables for rows where [sync_status = 'pending'] and
/// pushes each one to Firebase Data Connect (PostgreSQL via Cloud SQL) using
/// the type-safe generated [ExampleConnector].
///
/// Tables are processed in dependency order so foreign-key constraints in the
/// remote schema are always satisfied.
///
/// Call [syncNow] whenever connectivity is restored, or after a local write.
/// It is idempotent and safe to call concurrently (calls after the first are
/// no-ops until the current run finishes).
class FirebaseSyncService {
  FirebaseSyncService({required DatabaseHelper dbHelper})
      : _dbHelper = dbHelper;

  final DatabaseHelper _dbHelper;

  ExampleConnector get _connector => ExampleConnector.instance;

  bool _syncing = false;

  /// Publicly observable sync state — true while a sync run is in progress.
  /// Listen to this to drive UI indicators (e.g. the spinning refresh icon).
  final ValueNotifier<bool> isSyncing = ValueNotifier(false);

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Trigger a one-shot sync of all pending rows in every local table.
  /// Ensures an anonymous Firebase session exists before calling Data Connect.
  /// Safe to call multiple times — runs serially.
  Future<void> syncNow() async {
    if (_syncing) return;
    _syncing = true;
    isSyncing.value = true;
    AppLogger.i('Starting sync run…', tag: _tag);
    try {
      await _ensureSignedIn();
      await _syncAll();
    } catch (e, st) {
      AppLogger.e(
        'Sync run failed: $e',
        tag: _tag,
        error: e,
        stackTrace: st,
      );
    } finally {
      _syncing = false;
      isSyncing.value = false;
    }
  }

  // ── Auth ────────────────────────────────────────────────────────────────────

  Future<void> _ensureSignedIn() async {
    if (FirebaseAuth.instance.currentUser == null) {
      AppLogger.d('No Firebase user — signing in anonymously', tag: _tag);
      await FirebaseAuth.instance.signInAnonymously();
    }
  }

  // ── Main sync loop ──────────────────────────────────────────────────────────

  Future<void> _syncAll() async {
    final db = await _dbHelper.database;
    int total = 0;

    // Tables are processed in FK dependency order:
    //   branches → products → stock_items
    //                       → customers → customer_photos
    //                                   → sales → sale_customers
    //                                           → easy_payment_bills
    //                                             → easy_payment_transactions
    //                       → b2b_orders → b2b_order_items
    //                       → cris_records
    //                       → incoming_stock_log

    // 1. Branches — no sync_status column; always upsert all (seed data + any added branches)
    total += await _syncBranches(db);

    // 2. Products
    total += await _syncTablePending(db, 'products', _pushProduct);

    // 3. Stock items (→ products, branches)
    total += await _syncTablePending(db, 'stock_items', _pushStockItem);

    // 4. Customers
    total += await _syncTablePending(db, 'customers', _pushCustomer);

    // 5. Customer photos — no sync_status; use remote_url presence as readiness flag
    total += await _syncCustomerPhotos(db);

    // 6. Sales + sale_customers (→ branches, stock_items, customers)
    total += await _syncSales(db);

    // 7. Easy payment bills (→ sales)
    total += await _syncTablePending(db, 'easy_payment_bills', _pushEasyPaymentBill);

    // 8. Easy payment transactions (→ easy_payment_bills, branches)
    total += await _syncTablePending(db, 'easy_payment_transactions', _pushEasyPaymentTx);

    // 9. B2B orders + items (→ branches)
    total += await _syncB2bOrders(db);

    // 10. CRIS records (→ customers, nullable)
    total += await _syncTablePending(db, 'cris_records', _pushCrisRecord);

    // 11. Incoming stock log (→ branches)
    total += await _syncTablePending(db, 'incoming_stock_log', _pushIncomingLog);

    AppLogger.i('Sync complete ✓ — $total records pushed', tag: _tag);
  }

  // ── Generic pending-row helper ──────────────────────────────────────────────

  /// Queries all rows with [sync_status = 'pending'] in [table], calls [push]
  /// for each one, and marks successful rows as [sync_status = 'synced'].
  /// Failures are logged and left as 'pending' so they are retried next time.
  Future<int> _syncTablePending(
    Database db,
    String table,
    Future<void> Function(Map<String, dynamic> row) push,
  ) async {
    final rows = await db.query(
      table,
      where: "sync_status = 'pending'",
      orderBy: 'created_at ASC',
    );

    if (rows.isEmpty) return 0;
    AppLogger.d('[$table] ${rows.length} pending', tag: _tag);

    int count = 0;
    for (final row in rows) {
      try {
        await push(row);
        await db.update(
          table,
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
        AppLogger.d('✓ [$table] ${row['id']}', tag: _tag);
        count++;
      } catch (e, st) {
        AppLogger.e(
          '✗ [$table] ${row['id']}: $e',
          tag: _tag,
          error: e,
          stackTrace: st,
        );
        // Leave sync_status = 'pending' so it is retried on the next sync run.
      }
    }
    return count;
  }

  // ── Per-table sync specialisations ─────────────────────────────────────────

  /// Branches have no sync_status column — always upsert all rows.
  /// This is safe because the table is small and upsertBranch is idempotent.
  Future<int> _syncBranches(Database db) async {
    final rows = await db.query('branches');
    if (rows.isEmpty) return 0;
    AppLogger.d('[branches] ${rows.length} total (always upsert)', tag: _tag);

    int count = 0;
    for (final row in rows) {
      try {
        await _connector.upsertBranch(
          id: row['id'] as String,
          name: row['name'] as String,
          isActive: (row['is_active'] as int) == 1,
        ).execute();
        AppLogger.d('✓ [branches] ${row['id']}', tag: _tag);
        count++;
      } catch (e, st) {
        AppLogger.e(
          '✗ [branches] ${row['id']}: $e',
          tag: _tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    return count;
  }

  /// Customer photos have no sync_status column.
  /// A non-null remote_url means the photo has been uploaded to Firebase Storage
  /// and is ready to be registered in Data Connect.
  /// upsertCustomerPhoto is idempotent so re-running is safe.
  Future<int> _syncCustomerPhotos(Database db) async {
    final rows = await db.query(
      'customer_photos',
      where: 'remote_url IS NOT NULL',
    );
    if (rows.isEmpty) return 0;
    AppLogger.d('[customer_photos] ${rows.length} with remote_url', tag: _tag);

    int count = 0;
    for (final row in rows) {
      try {
        await _connector.upsertCustomerPhoto(
          id: row['id'] as String,
          customerId: row['customer_id'] as String,
          photoType: row['photo_type'] as String,
          createdAt: (row['created_at'] as num).toDouble(),
        ).remoteUrl(row['remote_url'] as String).execute();
        AppLogger.d('✓ [customer_photos] ${row['id']}', tag: _tag);
        count++;
      } catch (e, st) {
        AppLogger.e(
          '✗ [customer_photos] ${row['id']}: $e',
          tag: _tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    return count;
  }

  /// Sales and their associated sale_customers are synced atomically:
  /// the sale is pushed first, then its customers, then the row is marked synced.
  /// sale_customers have no sync_status column so they piggyback on their sale.
  Future<int> _syncSales(Database db) async {
    final rows = await db.query(
      'sales',
      where: "sync_status = 'pending'",
      orderBy: 'created_at ASC',
    );
    if (rows.isEmpty) return 0;
    AppLogger.d('[sales] ${rows.length} pending', tag: _tag);

    int count = 0;
    for (final row in rows) {
      try {
        await _pushSale(row);

        // Push all associated sale_customer junction rows.
        final saleCustomers = await db.query(
          'sale_customers',
          where: 'sale_id = ?',
          whereArgs: [row['id']],
        );
        for (final sc in saleCustomers) {
          await _connector.upsertSaleCustomer(
            id: sc['id'] as String,
            saleId: sc['sale_id'] as String,
            customerId: sc['customer_id'] as String,
            isPrimary: (sc['is_primary'] as int) == 1,
            sortOrder: sc['sort_order'] as int,
          ).execute();
        }

        await db.update(
          'sales',
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
        AppLogger.d(
          '✓ [sales] ${row['id']} + ${saleCustomers.length} customers',
          tag: _tag,
        );
        count++;
      } catch (e, st) {
        AppLogger.e(
          '✗ [sales] ${row['id']}: $e',
          tag: _tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    return count;
  }

  /// B2B orders and their items are synced together.
  /// b2b_order_items have no sync_status column so they piggyback on their order.
  Future<int> _syncB2bOrders(Database db) async {
    final rows = await db.query(
      'b2b_orders',
      where: "sync_status = 'pending'",
      orderBy: 'created_at ASC',
    );
    if (rows.isEmpty) return 0;
    AppLogger.d('[b2b_orders] ${rows.length} pending', tag: _tag);

    int count = 0;
    for (final row in rows) {
      try {
        await _pushB2bOrder(row);

        final items = await db.query(
          'b2b_order_items',
          where: 'order_id = ?',
          whereArgs: [row['id']],
          orderBy: 'sort_order ASC',
        );
        for (final item in items) {
          await _connector.upsertB2bOrderItem(
            id: item['id'] as String,
            orderId: item['order_id'] as String,
            serialNo: item['serial_no'] as String,
            modelNo: item['model_no'] as String,
            sortOrder: item['sort_order'] as int,
          ).stockItemId(item['stock_item_id'] as String?)
           .notes(item['notes'] as String?)
           .execute();
        }

        await db.update(
          'b2b_orders',
          {'sync_status': 'synced'},
          where: 'id = ?',
          whereArgs: [row['id']],
        );
        AppLogger.d(
          '✓ [b2b_orders] ${row['id']} + ${items.length} items',
          tag: _tag,
        );
        count++;
      } catch (e, st) {
        AppLogger.e(
          '✗ [b2b_orders] ${row['id']}: $e',
          tag: _tag,
          error: e,
          stackTrace: st,
        );
      }
    }
    return count;
  }

  // ── Row-level push helpers (read from SQLite map → call connector) ──────────

  Future<void> _pushProduct(Map<String, dynamic> r) async {
    await _connector.upsertProduct(
      id: r['id'] as String,
      productName: r['product_name'] as String,
      modelNo: r['model_no'] as String,
      price: (r['price'] as num).toDouble(),
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).imagePath(r['image_path'] as String?)
     .execute();
  }

  Future<void> _pushStockItem(Map<String, dynamic> r) async {
    await _connector.upsertStockItem(
      id: r['id'] as String,
      productId: r['product_id'] as String,
      branchCode: r['branch_code'] as String,
      serialNo: r['serial_no'] as String,
      status: r['status'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).execute();
  }

  Future<void> _pushCustomer(Map<String, dynamic> r) async {
    await _connector.upsertCustomer(
      id: r['id'] as String,
      nic: r['nic'] as String,
      name: r['name'] as String,
      phone: r['phone'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).description(r['description'] as String?)
     .execute();
  }

  Future<void> _pushSale(Map<String, dynamic> r) async {
    await _connector.upsertSale(
      id: r['id'] as String,
      blNumber: r['bl_number'] as String,
      branchCode: r['branch_code'] as String,
      stockItemId: r['stock_item_id'] as String,
      paymentPlan: r['payment_plan'] as String,
      downPayment: (r['down_payment'] as num).toDouble(),
      totalAmount: (r['total_amount'] as num).toDouble(),
      financedAmount: (r['financed_amount'] as num).toDouble(),
      status: r['status'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).durationMonths(r['duration_months'] as int?)
     .monthlyInstallment(
         r['monthly_installment'] != null
             ? (r['monthly_installment'] as num).toDouble()
             : null)
     .execute();
  }

  Future<void> _pushEasyPaymentBill(Map<String, dynamic> r) async {
    await _connector.upsertEasyPaymentBill(
      id: r['id'] as String,
      billNumber: r['bill_number'] as String,
      currentBalance: (r['current_balance'] as num).toDouble(),
      totalPaid: (r['total_paid'] as num).toDouble(),
      remainingMonths: r['remaining_months'] as int,
      monthlyInstallment: (r['monthly_installment'] as num).toDouble(),
      isActive: (r['is_active'] as int) == 1,
      status: r['status'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).saleId(r['sale_id'] as String?)
     .lastPaymentAmount(
         r['last_payment_amount'] != null
             ? (r['last_payment_amount'] as num).toDouble()
             : null)
     .lastPaymentDate(
         r['last_payment_date'] != null
             ? (r['last_payment_date'] as num).toDouble()
             : null)
     .execute();
  }

  Future<void> _pushEasyPaymentTx(Map<String, dynamic> r) async {
    await _connector.insertEasyPaymentTransaction(
      id: r['id'] as String,
      billId: r['bill_id'] as String,
      transactionType: r['transaction_type'] as String,
      branchCode: r['branch_code'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
    ).amount(r['amount'] != null ? (r['amount'] as num).toDouble() : null)
     .remainingMonths(r['remaining_months'] as int?)
     .newMonthlyInstallment(
         r['new_monthly_installment'] != null
             ? (r['new_monthly_installment'] as num).toDouble()
             : null)
     .notes(r['notes'] as String?)
     .execute();
  }

  Future<void> _pushB2bOrder(Map<String, dynamic> r) async {
    await _connector.upsertB2bOrder(
      id: r['id'] as String,
      orderRef: r['order_ref'] as String,
      sourceBranchId: r['source_branch'] as String,
      destinationBranchId: r['destination_branch'] as String,
      status: r['status'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).notes(r['notes'] as String?)
     .execute();
  }

  Future<void> _pushCrisRecord(Map<String, dynamic> r) async {
    await _connector.upsertCrisRecord(
      id: r['id'] as String,
      dNumber: r['d_number'] as String,
      bNumber: r['b_number'] as String,
      balance: (r['balance'] as num).toDouble(),
      status: r['status'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
      updatedAt: (r['updated_at'] as num).toDouble(),
    ).customerId(r['customer_id'] as String?)
     .execute();
  }

  Future<void> _pushIncomingLog(Map<String, dynamic> r) async {
    await _connector.insertIncomingStockLog(
      id: r['id'] as String,
      logType: r['log_type'] as String,
      serialNo: r['serial_no'] as String,
      modelNo: r['model_no'] as String,
      productName: r['product_name'] as String,
      branchCode: r['branch_code'] as String,
      createdAt: (r['created_at'] as num).toDouble(),
    ).referenceId(r['reference_id'] as String?)
     .notes(r['notes'] as String?)
     .execute();
  }
}
