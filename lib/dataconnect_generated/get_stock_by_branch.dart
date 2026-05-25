part of 'generated.dart';

class GetStockByBranchVariablesBuilder {
  String branchCode;

  final FirebaseDataConnect _dataConnect;
  GetStockByBranchVariablesBuilder(this._dataConnect, {required  this.branchCode,});
  Deserializer<GetStockByBranchData> dataDeserializer = (dynamic json)  => GetStockByBranchData.fromJson(jsonDecode(json));
  Serializer<GetStockByBranchVariables> varsSerializer = (GetStockByBranchVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetStockByBranchData, GetStockByBranchVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetStockByBranchData, GetStockByBranchVariables> ref() {
    GetStockByBranchVariables vars= GetStockByBranchVariables(branchCode: branchCode,);
    return _dataConnect.query("GetStockByBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetStockByBranchStockItems {
  final String id;
  final String serialNo;
  final String status;
  final GetStockByBranchStockItemsProduct product;
  final GetStockByBranchStockItemsBranch branch;
  final double createdAt;
  final double updatedAt;
  GetStockByBranchStockItems.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  status = nativeFromJson<String>(json['status']),
  product = GetStockByBranchStockItemsProduct.fromJson(json['product']),
  branch = GetStockByBranchStockItemsBranch.fromJson(json['branch']),
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

    final GetStockByBranchStockItems otherTyped = other as GetStockByBranchStockItems;
    return id == otherTyped.id && 
    serialNo == otherTyped.serialNo && 
    status == otherTyped.status && 
    product == otherTyped.product && 
    branch == otherTyped.branch && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serialNo.hashCode, status.hashCode, product.hashCode, branch.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['status'] = nativeToJson<String>(status);
    json['product'] = product.toJson();
    json['branch'] = branch.toJson();
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  GetStockByBranchStockItems({
    required this.id,
    required this.serialNo,
    required this.status,
    required this.product,
    required this.branch,
    required this.createdAt,
    required this.updatedAt,
  });
}

@immutable
class GetStockByBranchStockItemsProduct {
  final String id;
  final String productName;
  final String modelNo;
  GetStockByBranchStockItemsProduct.fromJson(dynamic json):
  
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

    final GetStockByBranchStockItemsProduct otherTyped = other as GetStockByBranchStockItemsProduct;
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

  GetStockByBranchStockItemsProduct({
    required this.id,
    required this.productName,
    required this.modelNo,
  });
}

@immutable
class GetStockByBranchStockItemsBranch {
  final String id;
  final String name;
  GetStockByBranchStockItemsBranch.fromJson(dynamic json):
  
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

    final GetStockByBranchStockItemsBranch otherTyped = other as GetStockByBranchStockItemsBranch;
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

  GetStockByBranchStockItemsBranch({
    required this.id,
    required this.name,
  });
}

@immutable
class GetStockByBranchData {
  final List<GetStockByBranchStockItems> stockItems;
  GetStockByBranchData.fromJson(dynamic json):
  
  stockItems = (json['stockItems'] as List<dynamic>)
        .map((e) => GetStockByBranchStockItems.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockByBranchData otherTyped = other as GetStockByBranchData;
    return stockItems == otherTyped.stockItems;
    
  }
  @override
  int get hashCode => stockItems.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['stockItems'] = stockItems.map((e) => e.toJson()).toList();
    return json;
  }

  GetStockByBranchData({
    required this.stockItems,
  });
}

@immutable
class GetStockByBranchVariables {
  final String branchCode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetStockByBranchVariables.fromJson(Map<String, dynamic> json):
  
  branchCode = nativeFromJson<String>(json['branchCode']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetStockByBranchVariables otherTyped = other as GetStockByBranchVariables;
    return branchCode == otherTyped.branchCode;
    
  }
  @override
  int get hashCode => branchCode.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branchCode'] = nativeToJson<String>(branchCode);
    return json;
  }

  GetStockByBranchVariables({
    required this.branchCode,
  });
}

