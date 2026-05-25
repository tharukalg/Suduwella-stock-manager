part of 'generated.dart';

class GetStockItemBySerialVariablesBuilder {
  String serialNo;

  final FirebaseDataConnect _dataConnect;
  GetStockItemBySerialVariablesBuilder(this._dataConnect, {required  this.serialNo,});
  Deserializer<GetStockItemBySerialData> dataDeserializer = (dynamic json)  => GetStockItemBySerialData.fromJson(jsonDecode(json));
  Serializer<GetStockItemBySerialVariables> varsSerializer = (GetStockItemBySerialVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetStockItemBySerialData, GetStockItemBySerialVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetStockItemBySerialData, GetStockItemBySerialVariables> ref() {
    GetStockItemBySerialVariables vars= GetStockItemBySerialVariables(serialNo: serialNo,);
    return _dataConnect.query("GetStockItemBySerial", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetStockItemBySerialStockItems {
  final String id;
  final String serialNo;
  final String status;
  final GetStockItemBySerialStockItemsProduct product;
  final GetStockItemBySerialStockItemsBranch branch;
  GetStockItemBySerialStockItems.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  status = nativeFromJson<String>(json['status']),
  product = GetStockItemBySerialStockItemsProduct.fromJson(json['product']),
  branch = GetStockItemBySerialStockItemsBranch.fromJson(json['branch']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockItemBySerialStockItems otherTyped = other as GetStockItemBySerialStockItems;
    return id == otherTyped.id && 
    serialNo == otherTyped.serialNo && 
    status == otherTyped.status && 
    product == otherTyped.product && 
    branch == otherTyped.branch;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serialNo.hashCode, status.hashCode, product.hashCode, branch.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['status'] = nativeToJson<String>(status);
    json['product'] = product.toJson();
    json['branch'] = branch.toJson();
    return json;
  }

  GetStockItemBySerialStockItems({
    required this.id,
    required this.serialNo,
    required this.status,
    required this.product,
    required this.branch,
  });
}

@immutable
class GetStockItemBySerialStockItemsProduct {
  final String id;
  final String productName;
  final String modelNo;
  GetStockItemBySerialStockItemsProduct.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  modelNo = nativeFromJson<String>(json['modelNo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockItemBySerialStockItemsProduct otherTyped = other as GetStockItemBySerialStockItemsProduct;
    return id == otherTyped.id && 
    productName == otherTyped.productName && 
    modelNo == otherTyped.modelNo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productName.hashCode, modelNo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productName'] = nativeToJson<String>(productName);
    json['modelNo'] = nativeToJson<String>(modelNo);
    return json;
  }

  GetStockItemBySerialStockItemsProduct({
    required this.id,
    required this.productName,
    required this.modelNo,
  });
}

@immutable
class GetStockItemBySerialStockItemsBranch {
  final String id;
  final String name;
  GetStockItemBySerialStockItemsBranch.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockItemBySerialStockItemsBranch otherTyped = other as GetStockItemBySerialStockItemsBranch;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetStockItemBySerialStockItemsBranch({
    required this.id,
    required this.name,
  });
}

@immutable
class GetStockItemBySerialData {
  final List<GetStockItemBySerialStockItems> stockItems;
  GetStockItemBySerialData.fromJson(dynamic json):
  
  stockItems = (json['stockItems'] as List<dynamic>)
        .map((e) => GetStockItemBySerialStockItems.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockItemBySerialData otherTyped = other as GetStockItemBySerialData;
    return stockItems == otherTyped.stockItems;
    
  }
  @override
  int get hashCode => stockItems.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['stockItems'] = stockItems.map((e) => e.toJson()).toList();
    return json;
  }

  GetStockItemBySerialData({
    required this.stockItems,
  });
}

@immutable
class GetStockItemBySerialVariables {
  final String serialNo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetStockItemBySerialVariables.fromJson(Map<String, dynamic> json):
  
  serialNo = nativeFromJson<String>(json['serialNo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockItemBySerialVariables otherTyped = other as GetStockItemBySerialVariables;
    return serialNo == otherTyped.serialNo;
    
  }
  @override
  int get hashCode => serialNo.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['serialNo'] = nativeToJson<String>(serialNo);
    return json;
  }

  GetStockItemBySerialVariables({
    required this.serialNo,
  });
}

