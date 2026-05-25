import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

class DeviceRegistrationModel {
  final String id;          // device UUID
  final String branchCode;
  final String? deviceLabel;
  final int createdAt;
  final int updatedAt;

  const DeviceRegistrationModel({
    required this.id,
    required this.branchCode,
    this.deviceLabel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceRegistrationModel.fromMap(Map<String, dynamic> m) =>
      DeviceRegistrationModel(
        id: m['id'] as String,
        branchCode: m['branch_code'] as String,
        deviceLabel: m['device_label'] as String?,
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'branch_code': branchCode,
        'device_label': deviceLabel,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class DeviceRegistrationDao {
  DeviceRegistrationDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  /// Returns the locally cached registration for [deviceId], or null.
  Future<DeviceRegistrationModel?> get(String deviceId) async {
    final rows = await (await _db).query(
      'device_registrations',
      where: 'id = ?',
      whereArgs: [deviceId],
    );
    return rows.isEmpty ? null : DeviceRegistrationModel.fromMap(rows.first);
  }

  /// Upserts (insert-or-replace) the registration — called after a successful
  /// Firebase lookup or admin registration.
  Future<void> upsert(DeviceRegistrationModel reg) async {
    await (await _db).insert(
      'device_registrations',
      reg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Removes the local registration row for [deviceId].
  Future<void> delete(String deviceId) async {
    await (await _db).delete(
      'device_registrations',
      where: 'id = ?',
      whereArgs: [deviceId],
    );
  }

  /// Returns all locally cached registrations (admin view).
  Future<List<DeviceRegistrationModel>> getAll() async {
    final rows = await (await _db).query(
      'device_registrations',
      orderBy: 'updated_at DESC',
    );
    return rows.map(DeviceRegistrationModel.fromMap).toList();
  }
}
