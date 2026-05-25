part of 'generated.dart';

class UpsertStockItemVariablesBuilder {
  String id;
  String productId;
  String branchCode;
  String serialNo;
  String status;
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;
  UpsertStockItemVariablesBuilder(this._dataConnect, {required  this.id,required  this.productId,required  this.branchCode,required  this.serialNo,required  this.status,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertStockItemData> dataDeserializer = (dynamic json)  => UpsertStockItemData.fromJson(jsonDecode(json));
  Serializer<UpsertStockItemVariables> varsSerializer = (UpsertStockItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertStockItemData, UpsertStockItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertStockItemData, UpsertStockItemVariables> ref() {
    UpsertStockItemVariables vars= UpsertStockItemVariables(id: id,productId: productId,branchCode: branchCode,serialNo: serialNo,status: status,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertStockItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertStockItemStockItemUpsert {
  final String id;
  UpsertStockItemStockItemUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertStockItemStockItemUpsert otherTyped = other as UpsertStockItemStockItemUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertStockItemStockItemUpsert({
    required this.id,
  });
}

@immutable
class UpsertStockItemData {
  final UpsertStockItemStockItemUpsert stockItem_upsert;
  UpsertStockItemData.fromJson(dynamic json):
  
  stockItem_upsert = UpsertStockItemStockItemUpsert.fromJson(json['stockItem_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertStockItemData otherTyped = other as UpsertStockItemData;
    return stockItem_upsert == otherTyped.stockItem_upsert;
    
  }
  @override
  int get hashCode => stockItem_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['stockItem_upsert'] = stockItem_upsert.toJson();
    return json;
  }

  UpsertStockItemData({
    required this.stockItem_upsert,
  });
}

@immutable
class UpsertStockItemVariables {
  final String id;
  final String productId;
  final String branchCode;
  final String serialNo;
  final String status;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertStockItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  productId = nativeFromJson<String>(json['productId']),
  branchCode = nativeFromJson<String>(json['branchCode']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertStockItemVariables otherTyped = other as UpsertStockItemVariables;
    return id == otherTyped.id && 
    productId == otherTyped.productId && 
    branchCode == otherTyped.branchCode && 
    serialNo == otherTyped.serialNo && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productId.hashCode, branchCode.hashCode, serialNo.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productId'] = nativeToJson<String>(productId);
    json['branchCode'] = nativeToJson<String>(branchCode);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertStockItemVariables({
    required this.id,
    required this.productId,
    required this.branchCode,
    required this.serialNo,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

