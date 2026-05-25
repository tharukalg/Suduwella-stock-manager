import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

enum SyncOperation { insert, update, delete }

extension SyncOperationX on SyncOperation {
  String get value => name;
  static SyncOperation fromString(String s) =>
      SyncOperation.values.firstWhere((e) => e.name == s, orElse: () => SyncOperation.insert);
}

// ── Model ─────────────────────────────────────────────────────────────────────

class SyncQueueEntry {
  final String id;
  final String tableName;
  final String recordId;
  final SyncOperation operation;
  final String payload; // JSON-encoded row map
  final int createdAt;
  final int? syncedAt;
  final String? errorMessage;
  final int retryCount;

  const SyncQueueEntry({
    required this.id,
    required this.tableName,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.syncedAt,
    this.errorMessage,
    this.retryCount = 0,
  });

  factory SyncQueueEntry.fromMap(Map<String, dynamic> m) => SyncQueueEntry(
        id: m['id'] as String,
        tableName: m['table_name'] as String,
        recordId: m['record_id'] as String,
        operation: SyncOperationX.fromString(m['operation'] as String),
        payload: m['payload'] as String,
        createdAt: m['created_at'] as int,
        syncedAt: m['synced_at'] as int?,
        errorMessage: m['error_message'] as String?,
        retryCount: m['retry_count'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'table_name': tableName,
        'record_id': recordId,
        'operation': operation.value,
        'payload': payload,
        'created_at': createdAt,
        'synced_at': syncedAt,
        'error_message': errorMessage,
        'retry_count': retryCount,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class SyncQueueDao {
  SyncQueueDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<void> enqueue({
    required String tableName,
    required String recordId,
    required SyncOperation operation,
    required String payload,
  }) async {
    final entry = SyncQueueEntry(
      id: generateId(),
      tableName: tableName,
      recordId: recordId,
      operation: operation,
      payload: payload,
      createdAt: nowMs(),
    );
    await (await _db).insert('sync_queue', entry.toMap());
  }

  // Returns the oldest un-synced rows, up to [limit]. Used by the sync service.
  Future<List<SyncQueueEntry>> getPending({int limit = 50}) async {
    final rows = await (await _db).query(
      'sync_queue',
      where: 'synced_at IS NULL',
      orderBy: 'created_at ASC',
      limit: limit,
    );
    return rows.map(SyncQueueEntry.fromMap).toList();
  }

  Future<void> markSynced(String id) async {
    await (await _db).update(
      'sync_queue',
      {'synced_at': nowMs(), 'error_message': null},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markFailed(String id, String errorMessage) async {
    await (await _db).rawUpdate(
      'UPDATE sync_queue SET error_message = ?, retry_count = retry_count + 1 WHERE id = ?',
      [errorMessage, id],
    );
  }

  // Removes rows that have already been pushed to Firebase.
  Future<void> clearSynced() async {
    await (await _db).delete(
      'sync_queue',
      where: 'synced_at IS NOT NULL',
    );
  }
}