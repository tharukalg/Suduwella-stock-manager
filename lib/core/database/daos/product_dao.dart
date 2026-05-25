import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

class ProductModel {
  final String id;
  final String productName;
  final String modelNo;
  final double price;
  final String? imagePath;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const ProductModel({
    required this.id,
    required this.productName,
    required this.modelNo,
    this.price = 0,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory ProductModel.create({
    required String productName,
    required String modelNo,
    double price = 0,
    String? imagePath,
  }) {
    final now = nowMs();
    return ProductModel(
      id: generateId(),
      productName: productName,
      modelNo: modelNo,
      price: price,
      imagePath: imagePath,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory ProductModel.fromMap(Map<String, dynamic> m) => ProductModel(
        id: m['id'] as String,
        productName: m['product_name'] as String,
        modelNo: m['model_no'] as String,
        price: (m['price'] as num?)?.toDouble() ?? 0,
        imagePath: m['image_path'] as String?,
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_name': productName,
        'model_no': modelNo,
        'price': price,
        'image_path': imagePath,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };

  ProductModel copyWith({double? price, String? imagePath, String? syncStatus}) => ProductModel(
        id: id,
        productName: productName,
        modelNo: modelNo,
        price: price ?? this.price,
        imagePath: imagePath ?? this.imagePath,
        createdAt: createdAt,
        updatedAt: nowMs(),
        syncStatus: syncStatus ?? this.syncStatus,
      );
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class ProductDao {
  ProductDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<List<ProductModel>> getAll() async {
    final rows = await (await _db).query('products', orderBy: 'product_name ASC');
    return rows.map(ProductModel.fromMap).toList();
  }

  Future<ProductModel?> getById(String id) async {
    final rows = await (await _db).query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : ProductModel.fromMap(rows.first);
  }

  Future<ProductModel?> getByModelNo(String modelNo) async {
    final rows = await (await _db).query(
      'products',
      where: 'model_no = ?',
      whereArgs: [modelNo],
    );
    return rows.isEmpty ? null : ProductModel.fromMap(rows.first);
  }

  Future<List<ProductModel>> search(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await (await _db).query(
      'products',
      where: 'LOWER(product_name) LIKE ? OR LOWER(model_no) LIKE ?',
      whereArgs: [q, q],
      orderBy: 'product_name ASC',
    );
    return rows.map(ProductModel.fromMap).toList();
  }

  Future<void> insert(ProductModel product) async {
    await (await _db).insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> update(ProductModel product) async {
    await (await _db).update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }
}