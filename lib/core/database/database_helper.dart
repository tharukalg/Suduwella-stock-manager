import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static const String _dbName = 'suduwella_stock.db';

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: kDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  // Enable foreign key enforcement.
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();
    for (final sql in kAllTableStatements) {
      batch.execute(sql);
    }
    for (final sql in kSeedStatements) {
      batch.execute(sql);
    }
    await batch.commit(noResult: true);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE products ADD COLUMN price REAL NOT NULL DEFAULT 0');
    }
    if (oldVersion < 3) {
      // Add device_registrations table (new in v3).
      await db.execute(tableCreateDeviceRegistrations);
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // ── DB flush ────────────────────────────────────────────────────────────────

  /// Deletes and fully recreates the local database.
  ///
  /// Preserves [device_id] and [active_branch] from app_settings so the device
  /// retains its identity and branch assignment after the flush. Call this
  /// from the dev screen only — all local data will be lost.
  Future<void> clearAndReset() async {
    // 1. Save identity keys before dropping the DB.
    String? savedDeviceId;
    String? savedActiveBranch;
    try {
      final db = await database;
      final rows = await db.rawQuery(
        "SELECT key, value FROM app_settings WHERE key IN ('device_id', 'active_branch')",
      );
      for (final r in rows) {
        final k = r['key'] as String;
        final v = r['value'] as String;
        if (k == 'device_id') savedDeviceId = v;
        if (k == 'active_branch') savedActiveBranch = v;
      }
    } catch (_) {}

    // 2. Close and delete the database file.
    await _db?.close();
    _db = null;
    final dbPath = await getDatabasesPath();
    await deleteDatabase(join(dbPath, _dbName));

    // 3. Reopen — this runs _onCreate and seeds the default data.
    _db = await _open();

    // 4. Restore the preserved identity keys.
    final now = DateTime.now().millisecondsSinceEpoch;
    if (savedDeviceId != null) {
      await _db!.insert(
        'app_settings',
        {'key': 'device_id', 'value': savedDeviceId, 'updated_at': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    if (savedActiveBranch != null) {
      await _db!.insert(
        'app_settings',
        {'key': 'active_branch', 'value': savedActiveBranch, 'updated_at': now},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
