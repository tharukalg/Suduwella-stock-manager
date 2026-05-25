import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

class BranchModel {
  final String id;
  final String name;
  final bool isActive;

  const BranchModel({
    required this.id,
    required this.name,
    this.isActive = true,
  });

  factory BranchModel.fromMap(Map<String, dynamic> m) => BranchModel(
        id: m['id'] as String,
        name: m['name'] as String,
        isActive: (m['is_active'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'is_active': isActive ? 1 : 0,
      };
}

class BranchDao {
  BranchDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<List<BranchModel>> getAll() async {
    final rows = await (await _db).query('branches', orderBy: 'name ASC');
    return rows.map(BranchModel.fromMap).toList();
  }

  Future<BranchModel?> getById(String id) async {
    final rows = await (await _db).query(
      'branches',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : BranchModel.fromMap(rows.first);
  }

  Future<void> upsert(BranchModel branch) async {
    await (await _db).insert(
      'branches',
      branch.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}