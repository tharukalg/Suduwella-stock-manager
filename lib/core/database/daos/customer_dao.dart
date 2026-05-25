import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

class CustomerModel {
  final String id;
  final String nic;
  final String name;
  final String phone;
  final String? description;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const CustomerModel({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory CustomerModel.create({
    required String nic,
    required String name,
    required String phone,
    String? description,
  }) {
    final now = nowMs();
    return CustomerModel(
      id: generateId(),
      nic: nic,
      name: name,
      phone: phone,
      description: description,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory CustomerModel.fromMap(Map<String, dynamic> m) => CustomerModel(
        id: m['id'] as String,
        nic: m['nic'] as String,
        name: m['name'] as String,
        phone: m['phone'] as String,
        description: m['description'] as String?,
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nic': nic,
        'name': name,
        'phone': phone,
        'description': description,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

// photo_type: 'id_photo' | 'selfie'
class CustomerPhotoModel {
  final String id;
  final String customerId;
  final String photoType;
  final String localPath;
  final String? remoteUrl;
  final int createdAt;

  const CustomerPhotoModel({
    required this.id,
    required this.customerId,
    required this.photoType,
    required this.localPath,
    this.remoteUrl,
    required this.createdAt,
  });

  factory CustomerPhotoModel.create({
    required String customerId,
    required String photoType,
    required String localPath,
  }) =>
      CustomerPhotoModel(
        id: generateId(),
        customerId: customerId,
        photoType: photoType,
        localPath: localPath,
        createdAt: nowMs(),
      );

  factory CustomerPhotoModel.fromMap(Map<String, dynamic> m) =>
      CustomerPhotoModel(
        id: m['id'] as String,
        customerId: m['customer_id'] as String,
        photoType: m['photo_type'] as String,
        localPath: m['local_path'] as String,
        remoteUrl: m['remote_url'] as String?,
        createdAt: m['created_at'] as int,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'customer_id': customerId,
        'photo_type': photoType,
        'local_path': localPath,
        'remote_url': remoteUrl,
        'created_at': createdAt,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class CustomerDao {
  CustomerDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<CustomerModel?> getByNic(String nic) async {
    final rows = await (await _db).query(
      'customers',
      where: 'nic = ?',
      whereArgs: [nic],
    );
    return rows.isEmpty ? null : CustomerModel.fromMap(rows.first);
  }

  Future<CustomerModel?> getById(String id) async {
    final rows = await (await _db).query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : CustomerModel.fromMap(rows.first);
  }

  // Inserts and returns the new row's id (no-op if NIC already exists).
  Future<String> insertIfNew(CustomerModel customer) async {
    final existing = await getByNic(customer.nic);
    if (existing != null) return existing.id;
    await (await _db).insert('customers', customer.toMap());
    return customer.id;
  }

  Future<void> update(CustomerModel customer) async {
    await (await _db).update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // ── Photos ────────────────────────────────────────────────────────────────

  Future<void> insertPhoto(CustomerPhotoModel photo) async {
    await (await _db).insert('customer_photos', photo.toMap());
  }

  Future<List<CustomerPhotoModel>> getPhotos(
    String customerId, {
    String? photoType,
  }) async {
    final where = photoType != null
        ? 'customer_id = ? AND photo_type = ?'
        : 'customer_id = ?';
    final args = photoType != null ? [customerId, photoType] : [customerId];
    final rows = await (await _db).query(
      'customer_photos',
      where: where,
      whereArgs: args,
      orderBy: 'created_at ASC',
    );
    return rows.map(CustomerPhotoModel.fromMap).toList();
  }

  Future<void> deletePhoto(String id) async {
    await (await _db).delete(
      'customer_photos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markPhotoUploaded(String id, String remoteUrl) async {
    await (await _db).update(
      'customer_photos',
      {'remote_url': remoteUrl},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}