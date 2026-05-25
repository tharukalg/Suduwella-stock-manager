import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

class AppSettingsDao {
  AppSettingsDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<String?> get(String key) async {
    final rows = await (await _db).query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    return rows.isEmpty ? null : rows.first['value'] as String;
  }

  Future<void> set(String key, String value) async {
    await (await _db).insert(
      'app_settings',
      {'key': key, 'value': value, 'updated_at': nowMs()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ── Typed convenience helpers ─────────────────────────────────────────────

  Future<String> getActiveBranch() async => await get('active_branch') ?? 'KH';

  Future<void> setActiveBranch(String branchCode) => set('active_branch', branchCode);

  Future<DateTime?> getLastSyncedAt() async {
    final raw = await get('last_synced_at');
    if (raw == null || raw == '0') return null;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(raw));
  }

  Future<void> setLastSyncedAt(DateTime dt) =>
      set('last_synced_at', dt.millisecondsSinceEpoch.toString());

  Future<String?> getAppUserId() => get('app_user_id');

  Future<void> setAppUserId(String uid) => set('app_user_id', uid);
}