import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

// log_type values
enum IncomingLogType { newItem, recoveredItem }

extension IncomingLogTypeX on IncomingLogType {
  String get value => switch (this) {
        IncomingLogType.newItem => 'new_item',
        IncomingLogType.recoveredItem => 'recovered_item',
      };

  static IncomingLogType fromString(String s) =>
      s == 'recovered_item' ? IncomingLogType.recoveredItem : IncomingLogType.newItem;
}

// ── Model ─────────────────────────────────────────────────────────────────────

class IncomingStockLogModel {
  final String id;
  final IncomingLogType logType;
  final String serialNo;
  final String modelNo;
  final String productName;
  final String branchCode;
  // For recovered items: the original sale_id or cris_record id
  final String? referenceId;
  final String? notes;
  final int createdAt;
  final String syncStatus;

  const IncomingStockLogModel({
    required this.id,
    required this.logType,
    required this.serialNo,
    required this.modelNo,
    required this.productName,
    required this.branchCode,
    this.referenceId,
    this.notes,
    required this.createdAt,
    this.syncStatus = 'pending',
  });

  factory IncomingStockLogModel.create({
    required IncomingLogType logType,
    required String serialNo,
    required String modelNo,
    required String productName,
    required String branchCode,
    String? referenceId,
    String? notes,
  }) =>
      IncomingStockLogModel(
        id: generateId(),
        logType: logType,
        serialNo: serialNo,
        modelNo: modelNo,
        productName: productName,
        branchCode: branchCode,
        referenceId: referenceId,
        notes: notes,
        createdAt: nowMs(),
      );

  factory IncomingStockLogModel.fromMap(Map<String, dynamic> m) => IncomingStockLogModel(
        id: m['id'] as String,
        logType: IncomingLogTypeX.fromString(m['log_type'] as String),
        serialNo: m['serial_no'] as String,
        modelNo: m['model_no'] as String,
        productName: m['product_name'] as String,
        branchCode: m['branch_code'] as String,
        referenceId: m['reference_id'] as String?,
        notes: m['notes'] as String?,
        createdAt: m['created_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'log_type': logType.value,
        'serial_no': serialNo,
        'model_no': modelNo,
        'product_name': productName,
        'branch_code': branchCode,
        'reference_id': referenceId,
        'notes': notes,
        'created_at': createdAt,
        'sync_status': syncStatus,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class IncomingStockDao {
  IncomingStockDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<void> insert(IncomingStockLogModel log) async {
    await (await _db).insert('incoming_stock_log', log.toMap());
  }

  Future<List<IncomingStockLogModel>> getByBranch(
    String branchCode, {
    IncomingLogType? logType,
    int limit = 50,
  }) async {
    final where = logType != null
        ? 'branch_code = ? AND log_type = ?'
        : 'branch_code = ?';
    final args = logType != null ? [branchCode, logType.value] : [branchCode];
    final rows = await (await _db).query(
      'incoming_stock_log',
      where: where,
      whereArgs: args,
      orderBy: 'created_at DESC',
      limit: limit,
    );
    return rows.map(IncomingStockLogModel.fromMap).toList();
  }

  Future<IncomingStockLogModel?> getBySerialNo(String serialNo) async {
    final rows = await (await _db).query(
      'incoming_stock_log',
      where: 'serial_no = ?',
      whereArgs: [serialNo],
      orderBy: 'created_at DESC',
      limit: 1,
    );
    return rows.isEmpty ? null : IncomingStockLogModel.fromMap(rows.first);
  }
}