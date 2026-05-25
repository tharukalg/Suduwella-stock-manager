import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

// payment_plan values
enum PaymentPlan { interestFree, directEasyPayment }

extension PaymentPlanX on PaymentPlan {
  String get value => switch (this) {
        PaymentPlan.interestFree => 'interest_free',
        PaymentPlan.directEasyPayment => 'direct_easy_payment',
      };

  static PaymentPlan fromString(String s) =>
      s == 'direct_easy_payment' ? PaymentPlan.directEasyPayment : PaymentPlan.interestFree;
}

// sale status values
enum SaleStatus { active, settled, recovered }

extension SaleStatusX on SaleStatus {
  String get value => name;
  static SaleStatus fromString(String s) =>
      SaleStatus.values.firstWhere((e) => e.name == s, orElse: () => SaleStatus.active);
}

// ── Models ────────────────────────────────────────────────────────────────────

class SaleModel {
  final String id;
  final String blNumber;
  final String branchCode;
  final String stockItemId;
  final PaymentPlan paymentPlan;
  final double downPayment;
  final double totalAmount;
  final double financedAmount;
  final int? durationMonths;
  final double? monthlyInstallment;
  final SaleStatus status;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const SaleModel({
    required this.id,
    required this.blNumber,
    required this.branchCode,
    required this.stockItemId,
    required this.paymentPlan,
    required this.downPayment,
    required this.totalAmount,
    required this.financedAmount,
    this.durationMonths,
    this.monthlyInstallment,
    this.status = SaleStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory SaleModel.create({
    required String blNumber,
    required String branchCode,
    required String stockItemId,
    required PaymentPlan paymentPlan,
    required double downPayment,
    required double totalAmount,
    required double financedAmount,
    int? durationMonths,
    double? monthlyInstallment,
  }) {
    final now = nowMs();
    return SaleModel(
      id: generateId(),
      blNumber: blNumber,
      branchCode: branchCode,
      stockItemId: stockItemId,
      paymentPlan: paymentPlan,
      downPayment: downPayment,
      totalAmount: totalAmount,
      financedAmount: financedAmount,
      durationMonths: durationMonths,
      monthlyInstallment: monthlyInstallment,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory SaleModel.fromMap(Map<String, dynamic> m) => SaleModel(
        id: m['id'] as String,
        blNumber: m['bl_number'] as String,
        branchCode: m['branch_code'] as String,
        stockItemId: m['stock_item_id'] as String,
        paymentPlan: PaymentPlanX.fromString(m['payment_plan'] as String),
        downPayment: (m['down_payment'] as num).toDouble(),
        totalAmount: (m['total_amount'] as num).toDouble(),
        financedAmount: (m['financed_amount'] as num).toDouble(),
        durationMonths: m['duration_months'] as int?,
        monthlyInstallment: m['monthly_installment'] != null
            ? (m['monthly_installment'] as num).toDouble()
            : null,
        status: SaleStatusX.fromString(m['status'] as String),
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bl_number': blNumber,
        'branch_code': branchCode,
        'stock_item_id': stockItemId,
        'payment_plan': paymentPlan.value,
        'down_payment': downPayment,
        'total_amount': totalAmount,
        'financed_amount': financedAmount,
        'duration_months': durationMonths,
        'monthly_installment': monthlyInstallment,
        'status': status.value,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

class SaleCustomerModel {
  final String id;
  final String saleId;
  final String customerId;
  final bool isPrimary;
  final int sortOrder;

  const SaleCustomerModel({
    required this.id,
    required this.saleId,
    required this.customerId,
    this.isPrimary = false,
    this.sortOrder = 0,
  });

  factory SaleCustomerModel.create({
    required String saleId,
    required String customerId,
    bool isPrimary = false,
    int sortOrder = 0,
  }) =>
      SaleCustomerModel(
        id: generateId(),
        saleId: saleId,
        customerId: customerId,
        isPrimary: isPrimary,
        sortOrder: sortOrder,
      );

  factory SaleCustomerModel.fromMap(Map<String, dynamic> m) => SaleCustomerModel(
        id: m['id'] as String,
        saleId: m['sale_id'] as String,
        customerId: m['customer_id'] as String,
        isPrimary: (m['is_primary'] as int) == 1,
        sortOrder: m['sort_order'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'sale_id': saleId,
        'customer_id': customerId,
        'is_primary': isPrimary ? 1 : 0,
        'sort_order': sortOrder,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class SaleDao {
  SaleDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  // Inserts sale + all customer junction rows atomically.
  Future<void> insertSale(
    SaleModel sale,
    List<SaleCustomerModel> customers,
  ) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert('sales', sale.toMap());
      for (final c in customers) {
        await txn.insert('sale_customers', c.toMap());
      }
    });
  }

  Future<SaleModel?> getByBlNumber(String blNumber) async {
    final rows = await (await _db).query(
      'sales',
      where: 'bl_number = ?',
      whereArgs: [blNumber],
    );
    return rows.isEmpty ? null : SaleModel.fromMap(rows.first);
  }

  Future<SaleModel?> getById(String id) async {
    final rows = await (await _db).query(
      'sales',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : SaleModel.fromMap(rows.first);
  }

  Future<List<SaleModel>> getByBranch(
    String branchCode, {
    SaleStatus? status,
  }) async {
    final where = status != null
        ? 'branch_code = ? AND status = ?'
        : 'branch_code = ?';
    final args = status != null ? [branchCode, status.value] : [branchCode];
    final rows = await (await _db).query(
      'sales',
      where: where,
      whereArgs: args,
      orderBy: 'created_at DESC',
    );
    return rows.map(SaleModel.fromMap).toList();
  }

  Future<List<SaleCustomerModel>> getCustomers(String saleId) async {
    final rows = await (await _db).query(
      'sale_customers',
      where: 'sale_id = ?',
      whereArgs: [saleId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(SaleCustomerModel.fromMap).toList();
  }

  Future<void> updateStatus(String id, SaleStatus status) async {
    await (await _db).update(
      'sales',
      {'status': status.value, 'updated_at': nowMs(), 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}