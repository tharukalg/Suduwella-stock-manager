import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

enum CrisStatus { overdue, review, settled }

extension CrisStatusX on CrisStatus {
  String get value => name;
  static CrisStatus fromString(String s) =>
      CrisStatus.values.firstWhere((e) => e.name == s, orElse: () => CrisStatus.overdue);
}

// ── Model ─────────────────────────────────────────────────────────────────────

class CrisRecordModel {
  final String id;
  final String? customerId;
  final String dNumber;
  final String bNumber;
  final double balance;
  final CrisStatus status;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const CrisRecordModel({
    required this.id,
    this.customerId,
    required this.dNumber,
    required this.bNumber,
    required this.balance,
    this.status = CrisStatus.overdue,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory CrisRecordModel.create({
    required String dNumber,
    required String bNumber,
    required double balance,
    String? customerId,
    CrisStatus status = CrisStatus.overdue,
  }) {
    final now = nowMs();
    return CrisRecordModel(
      id: generateId(),
      customerId: customerId,
      dNumber: dNumber,
      bNumber: bNumber,
      balance: balance,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory CrisRecordModel.fromMap(Map<String, dynamic> m) => CrisRecordModel(
        id: m['id'] as String,
        customerId: m['customer_id'] as String?,
        dNumber: m['d_number'] as String,
        bNumber: m['b_number'] as String,
        balance: (m['balance'] as num).toDouble(),
        status: CrisStatusX.fromString(m['status'] as String),
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'd_number': dNumber,
        'b_number': bNumber,
        'balance': balance,
        'status': status.value,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class CrisDao {
  CrisDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<List<CrisRecordModel>> getAll({CrisStatus? status}) async {
    final where = status != null ? 'status = ?' : null;
    final args = status != null ? [status.value] : null;
    final rows = await (await _db).query(
      'cris_records',
      where: where,
      whereArgs: args,
      orderBy: 'updated_at DESC',
    );
    return rows.map(CrisRecordModel.fromMap).toList();
  }

  Future<CrisRecordModel?> getByDNumber(String dNumber) async {
    final rows = await (await _db).query(
      'cris_records',
      where: 'd_number = ?',
      whereArgs: [dNumber],
    );
    return rows.isEmpty ? null : CrisRecordModel.fromMap(rows.first);
  }

  // Returns all CRIS records linked to a customer (used in CRIS search by NIC).
  Future<List<CrisRecordModel>> getByCustomer(String customerId) async {
    final rows = await (await _db).query(
      'cris_records',
      where: 'customer_id = ?',
      whereArgs: [customerId],
      orderBy: 'updated_at DESC',
    );
    return rows.map(CrisRecordModel.fromMap).toList();
  }

  // Returns count of overdue + review records — used for the homepage alert badge.
  Future<int> getActiveAlertCount() async {
    final result = await (await _db).rawQuery(
      "SELECT COUNT(*) AS cnt FROM cris_records WHERE status IN ('overdue', 'review')",
    );
    return (result.first['cnt'] as int?) ?? 0;
  }

  Future<void> insert(CrisRecordModel record) async {
    await (await _db).insert(
      'cris_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> updateStatus(String id, CrisStatus status) async {
    await (await _db).update(
      'cris_records',
      {'status': status.value, 'updated_at': nowMs(), 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Associates a CRIS record with a customer after NIC matching.
  Future<void> linkCustomer(String id, String customerId) async {
    await (await _db).update(
      'cris_records',
      {'customer_id': customerId, 'updated_at': nowMs(), 'sync_status': 'pending'},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}