import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

enum B2bOrderStatus { pending, dispatched, received, cancelled }

extension B2bOrderStatusX on B2bOrderStatus {
  String get value => name;
  static B2bOrderStatus fromString(String s) => B2bOrderStatus.values
      .firstWhere((e) => e.name == s, orElse: () => B2bOrderStatus.pending);
}

// ── Models ────────────────────────────────────────────────────────────────────

class B2bOrderModel {
  final String id;
  final String orderRef;
  final String sourceBranch;
  final String destinationBranch;
  final B2bOrderStatus status;
  final String? notes;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const B2bOrderModel({
    required this.id,
    required this.orderRef,
    required this.sourceBranch,
    required this.destinationBranch,
    this.status = B2bOrderStatus.pending,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory B2bOrderModel.create({
    required String sourceBranch,
    required String destinationBranch,
    String? notes,
  }) {
    final now = nowMs();
    return B2bOrderModel(
      id: generateId(),
      orderRef: 'B2B-${now.toRadixString(16).toUpperCase()}',
      sourceBranch: sourceBranch,
      destinationBranch: destinationBranch,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory B2bOrderModel.fromMap(Map<String, dynamic> m) => B2bOrderModel(
        id: m['id'] as String,
        orderRef: m['order_ref'] as String,
        sourceBranch: m['source_branch'] as String,
        destinationBranch: m['destination_branch'] as String,
        status: B2bOrderStatusX.fromString(m['status'] as String),
        notes: m['notes'] as String?,
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_ref': orderRef,
        'source_branch': sourceBranch,
        'destination_branch': destinationBranch,
        'status': status.value,
        'notes': notes,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

class B2bOrderItemModel {
  final String id;
  final String orderId;
  final String? stockItemId;
  final String serialNo;
  final String modelNo;
  final String? notes;
  final int sortOrder;

  const B2bOrderItemModel({
    required this.id,
    required this.orderId,
    this.stockItemId,
    required this.serialNo,
    required this.modelNo,
    this.notes,
    this.sortOrder = 0,
  });

  factory B2bOrderItemModel.create({
    required String orderId,
    required String serialNo,
    required String modelNo,
    String? stockItemId,
    String? notes,
    int sortOrder = 0,
  }) =>
      B2bOrderItemModel(
        id: generateId(),
        orderId: orderId,
        stockItemId: stockItemId,
        serialNo: serialNo,
        modelNo: modelNo,
        notes: notes,
        sortOrder: sortOrder,
      );

  factory B2bOrderItemModel.fromMap(Map<String, dynamic> m) => B2bOrderItemModel(
        id: m['id'] as String,
        orderId: m['order_id'] as String,
        stockItemId: m['stock_item_id'] as String?,
        serialNo: m['serial_no'] as String,
        modelNo: m['model_no'] as String,
        notes: m['notes'] as String?,
        sortOrder: m['sort_order'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'stock_item_id': stockItemId,
        'serial_no': serialNo,
        'model_no': modelNo,
        'notes': notes,
        'sort_order': sortOrder,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class B2bDao {
  B2bDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  // Inserts order + all items atomically.
  Future<void> insertOrder(
    B2bOrderModel order,
    List<B2bOrderItemModel> items,
  ) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert('b2b_orders', order.toMap());
      for (var i = 0; i < items.length; i++) {
        await txn.insert('b2b_order_items', items[i].toMap());
      }
    });
  }

  Future<B2bOrderModel?> getById(String id) async {
    final rows = await (await _db).query(
      'b2b_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : B2bOrderModel.fromMap(rows.first);
  }

  Future<List<B2bOrderModel>> getBySourceBranch(
    String branchCode, {
    B2bOrderStatus? status,
  }) async {
    final where = status != null
        ? 'source_branch = ? AND status = ?'
        : 'source_branch = ?';
    final args = status != null ? [branchCode, status.value] : [branchCode];
    final rows = await (await _db).query(
      'b2b_orders',
      where: where,
      whereArgs: args,
      orderBy: 'created_at DESC',
    );
    return rows.map(B2bOrderModel.fromMap).toList();
  }

  Future<List<B2bOrderItemModel>> getItems(String orderId) async {
    final rows = await (await _db).query(
      'b2b_order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
      orderBy: 'sort_order ASC',
    );
    return rows.map(B2bOrderItemModel.fromMap).toList();
  }

  Future<void> updateStatus(String id, B2bOrderStatus status) async {
    await (await _db).update(
      'b2b_orders',
      {'status': status.value, 'updated_at': nowMs(), 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
