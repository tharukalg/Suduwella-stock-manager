part of 'generated.dart';

class GetActiveSalesByBranchVariablesBuilder {
  String branchCode;

  final FirebaseDataConnect _dataConnect;
  GetActiveSalesByBranchVariablesBuilder(this._dataConnect, {required  this.branchCode,});
  Deserializer<GetActiveSalesByBranchData> dataDeserializer = (dynamic json)  => GetActiveSalesByBranchData.fromJson(jsonDecode(json));
  Serializer<GetActiveSalesByBranchVariables> varsSerializer = (GetActiveSalesByBranchVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetActiveSalesByBranchData, GetActiveSalesByBranchVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetActiveSalesByBranchData, GetActiveSalesByBranchVariables> ref() {
    GetActiveSalesByBranchVariables vars= GetActiveSalesByBranchVariables(branchCode: branchCode,);
    return _dataConnect.query("GetActiveSalesByBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetActiveSalesByBranchSales {
  final String id;
  final String blNumber;
  final String paymentPlan;
  final double totalAmount;
  final String status;
  final double createdAt;
  final GetActiveSalesByBranchSalesStockItem stockItem;
  GetActiveSalesByBranchSales.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  blNumber = nativeFromJson<String>(json['blNumber']),
  paymentPlan = nativeFromJson<String>(json['paymentPlan']),
  totalAmount = nativeFromJson<double>(json['totalAmount']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  stockItem = GetActiveSalesByBranchSalesStockItem.fromJson(json['stockItem']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveSalesByBranchSales otherTyped = other as GetActiveSalesByBranchSales;
    return id == otherTyped.id && 
    blNumber == otherTyped.blNumber && 
    paymentPlan == otherTyped.paymentPlan && 
    totalAmount == otherTyped.totalAmount && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    stockItem == otherTyped.stockItem;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, blNumber.hashCode, paymentPlan.hashCode, totalAmount.hashCode, status.hashCode, createdAt.hashCode, stockItem.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['blNumber'] = nativeToJson<String>(blNumber);
    json['paymentPlan'] = nativeToJson<String>(paymentPlan);
    json['totalAmount'] = nativeToJson<double>(totalAmount);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['stockItem'] = stockItem.toJson();
    return json;
  }

  GetActiveSalesByBranchSales({
    required this.id,
    required this.blNumber,
    required this.paymentPlan,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.stockItem,
  });
}

@immutable
class GetActiveSalesByBranchSalesStockItem {
  final String id;
  final String serialNo;
  final GetActiveSalesByBranchSalesStockItemProduct product;
  GetActiveSalesByBranchSalesStockItem.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  product = GetActiveSalesByBranchSalesStockItemProduct.fromJson(json['product']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveSalesByBranchSalesStockItem otherTyped = other as GetActiveSalesByBranchSalesStockItem;
    return id == otherTyped.id && 
    serialNo == otherTyped.serialNo && 
    product == otherTyped.product;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, serialNo.hashCode, product.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['product'] = product.toJson();
    return json;
  }

  GetActiveSalesByBranchSalesStockItem({
    required this.id,
    required this.serialNo,
    required this.product,
  });
}

@immutable
class GetActiveSalesByBranchSalesStockItemProduct {
  final String productName;
  final String modelNo;
  GetActiveSalesByBranchSalesStockItemProduct.fromJson(dynamic json):
  
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

    final GetActiveSalesByBranchSalesStockItemProduct otherTyped = other as GetActiveSalesByBranchSalesStockItemProduct;
    return productName == otherTyped.productName && 
    modelNo == otherTyped.modelNo;
    
  }
  @override
  int get hashCode => Object.hashAll([productName.hashCode, modelNo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['productName'] = nativeToJson<String>(productName);
    json['modelNo'] = nativeToJson<String>(modelNo);
    return json;
  }

  GetActiveSalesByBranchSalesStockItemProduct({
    required this.productName,
    required this.modelNo,
  });
}

@immutable
class GetActiveSalesByBranchData {
  final List<GetActiveSalesByBranchSales> sales;
  GetActiveSalesByBranchData.fromJson(dynamic json):
  
  sales = (json['sales'] as List<dynamic>)
        .map((e) => GetActiveSalesByBranchSales.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveSalesByBranchData otherTyped = other as GetActiveSalesByBranchData;
    return sales == otherTyped.sales;
    
  }
  @override
  int get hashCode => sales.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sales'] = sales.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveSalesByBranchData({
    required this.sales,
  });
}

@immutable
class GetActiveSalesByBranchVariables {
  final String branchCode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetActiveSalesByBranchVariables.fromJson(Map<String, dynamic> json):
  
  branchCode = nativeFromJson<String>(json['branchCode']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveSalesByBranchVariables otherTyped = other as GetActiveSalesByBranchVariables;
    return branchCode == otherTyped.branchCode;
    
  }
  @override
  int get hashCode => branchCode.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branchCode'] = nativeToJson<String>(branchCode);
    return json;
  }

  GetActiveSalesByBranchVariables({
    required this.branchCode,
  });
}

