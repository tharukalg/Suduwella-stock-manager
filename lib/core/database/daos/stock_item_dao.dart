import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

// status values match the DB constraint
enum StockStatus { available, sold, b2bTransit, recovered, writtenOff }

extension StockStatusX on StockStatus {
  String get value => switch (this) {
        StockStatus.available => 'available',
        StockStatus.sold => 'sold',
        StockStatus.b2bTransit => 'b2b_transit',
        StockStatus.recovered => 'recovered',
        StockStatus.writtenOff => 'written_off',
      };

  static StockStatus fromString(String s) => switch (s) {
        'sold' => StockStatus.sold,
        'b2b_transit' => StockStatus.b2bTransit,
        'recovered' => StockStatus.recovered,
        'written_off' => StockStatus.writtenOff,
        _ => StockStatus.available,
      };
}

class StockItemModel {
  final String id;
  final String productId;
  final String serialNo;
  final String branchCode;
  final StockStatus status;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const StockItemModel({
    required this.id,
    required this.productId,
    required this.serialNo,
    required this.branchCode,
    this.status = StockStatus.available,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory StockItemModel.create({
    required String productId,
    required String serialNo,
    required String branchCode,
  }) {
    final now = nowMs();
    return StockItemModel(
      id: generateId(),
      productId: productId,
      serialNo: serialNo,
      branchCode: branchCode,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory StockItemModel.fromMap(Map<String, dynamic> m) => StockItemModel(
        id: m['id'] as String,
        productId: m['product_id'] as String,
        serialNo: m['serial_no'] as String,
        branchCode: m['branch_code'] as String,
        status: StockStatusX.fromString(m['status'] as String),
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_id': productId,
        'serial_no': serialNo,
        'branch_code': branchCode,
        'status': status.value,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

// Flat row returned by getStockSummary — one row per (product, branch) pair.
// The BLoC aggregates these into StockItem(branchStock: Map<String, int>).
class StockSummaryRow {
  final String productId;
  final String productName;
  final String modelNo;
  final String? imagePath;
  final String branchCode;
  final int unitCount;

  const StockSummaryRow({
    required this.productId,
    required this.productName,
    required this.modelNo,
    this.imagePath,
    required this.branchCode,
    required this.unitCount,
  });
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class StockItemDao {
  StockItemDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<StockItemModel?> getBySerialNo(String serialNo) async {
    final rows = await (await _db).query(
      'stock_items',
      where: 'serial_no = ?',
      whereArgs: [serialNo],
    );
    return rows.isEmpty ? null : StockItemModel.fromMap(rows.first);
  }

  Future<List<StockItemModel>> getByBranch(
    String branchCode, {
    StockStatus? status,
  }) async {
    final where = status != null
        ? 'branch_code = ? AND status = ?'
        : 'branch_code = ?';
    final args = status != null ? [branchCode, status.value] : [branchCode];
    final rows = await (await _db).query(
      'stock_items',
      where: where,
      whereArgs: args,
      orderBy: 'created_at DESC',
    );
    return rows.map(StockItemModel.fromMap).toList();
  }

  // Returns one row per (product, branch) — used to build the stock page inventory grid.
  Future<List<StockSummaryRow>> getStockSummary() async {
    final rows = await (await _db).rawQuery('''
      SELECT
        p.id           AS product_id,
        p.product_name,
        p.model_no,
        p.image_path,
        si.branch_code,
        COUNT(si.id)   AS unit_count
      FROM products p
      LEFT JOIN stock_items si
        ON si.product_id = p.id AND si.status = 'available'
      GROUP BY p.id, si.branch_code
      ORDER BY p.product_name ASC
    ''');

    return rows.map((r) => StockSummaryRow(
          productId: r['product_id'] as String,
          productName: r['product_name'] as String,
          modelNo: r['model_no'] as String,
          imagePath: r['image_path'] as String?,
          branchCode: (r['branch_code'] as String?) ?? '',
          unitCount: (r['unit_count'] as int?) ?? 0,
        )).toList();
  }

  Future<void> insert(StockItemModel item) async {
    await (await _db).insert(
      'stock_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateStatus(String id, StockStatus status) async {
    await (await _db).update(
      'stock_items',
      {'status': status.value, 'updated_at': nowMs(), 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> transferBranch(String id, String newBranchCode) async {
    await (await _db).update(
      'stock_items',
      {
        'branch_code': newBranchCode,
        'updated_at': nowMs(),
        'sync_status': 'pending',
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}