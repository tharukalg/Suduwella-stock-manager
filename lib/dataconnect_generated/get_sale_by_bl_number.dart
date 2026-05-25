part of 'generated.dart';

class GetSaleByBlNumberVariablesBuilder {
  String blNumber;

  final FirebaseDataConnect _dataConnect;
  GetSaleByBlNumberVariablesBuilder(this._dataConnect, {required  this.blNumber,});
  Deserializer<GetSaleByBlNumberData> dataDeserializer = (dynamic json)  => GetSaleByBlNumberData.fromJson(jsonDecode(json));
  Serializer<GetSaleByBlNumberVariables> varsSerializer = (GetSaleByBlNumberVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetSaleByBlNumberData, GetSaleByBlNumberVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetSaleByBlNumberData, GetSaleByBlNumberVariables> ref() {
    GetSaleByBlNumberVariables vars= GetSaleByBlNumberVariables(blNumber: blNumber,);
    return _dataConnect.query("GetSaleByBlNumber", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetSaleByBlNumberSales {
  final String id;
  final String blNumber;
  final String paymentPlan;
  final double downPayment;
  final double totalAmount;
  final double financedAmount;
  final int? durationMonths;
  final double? monthlyInstallment;
  final String status;
  final double createdAt;
  final GetSaleByBlNumberSalesBranch branch;
  final GetSaleByBlNumberSalesStockItem stockItem;
  GetSaleByBlNumberSales.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  blNumber = nativeFromJson<String>(json['blNumber']),
  paymentPlan = nativeFromJson<String>(json['paymentPlan']),
  downPayment = nativeFromJson<double>(json['downPayment']),
  totalAmount = nativeFromJson<double>(json['totalAmount']),
  financedAmount = nativeFromJson<double>(json['financedAmount']),
  durationMonths = json['durationMonths'] == null ? null : nativeFromJson<int>(json['durationMonths']),
  monthlyInstallment = json['monthlyInstallment'] == null ? null : nativeFromJson<double>(json['monthlyInstallment']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  branch = GetSaleByBlNumberSalesBranch.fromJson(json['branch']),
  stockItem = GetSaleByBlNumberSalesStockItem.fromJson(json['stockItem']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSaleByBlNumberSales otherTyped = other as GetSaleByBlNumberSales;
    return id == otherTyped.id && 
    blNumber == otherTyped.blNumber && 
    paymentPlan == otherTyped.paymentPlan && 
    downPayment == otherTyped.downPayment && 
    totalAmount == otherTyped.totalAmount && 
    financedAmount == otherTyped.financedAmount && 
    durationMonths == otherTyped.durationMonths && 
    monthlyInstallment == otherTyped.monthlyInstallment && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    branch == otherTyped.branch && 
    stockItem == otherTyped.stockItem;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, blNumber.hashCode, paymentPlan.hashCode, downPayment.hashCode, totalAmount.hashCode, financedAmount.hashCode, durationMonths.hashCode, monthlyInstallment.hashCode, status.hashCode, createdAt.hashCode, branch.hashCode, stockItem.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['blNumber'] = nativeToJson<String>(blNumber);
    json['paymentPlan'] = nativeToJson<String>(paymentPlan);
    json['downPayment'] = nativeToJson<double>(downPayment);
    json['totalAmount'] = nativeToJson<double>(totalAmount);
    json['financedAmount'] = nativeToJson<double>(financedAmount);
    if (durationMonths != null) {
      json['durationMonths'] = nativeToJson<int?>(durationMonths);
    }
    if (monthlyInstallment != null) {
      json['monthlyInstallment'] = nativeToJson<double?>(monthlyInstallment);
    }
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['branch'] = branch.toJson();
    json['stockItem'] = stockItem.toJson();
    return json;
  }

  GetSaleByBlNumberSales({
    required this.id,
    required this.blNumber,
    required this.paymentPlan,
    required this.downPayment,
    required this.totalAmount,
    required this.financedAmount,
    this.durationMonths,
    this.monthlyInstallment,
    required this.status,
    required this.createdAt,
    required this.branch,
    required this.stockItem,
  });
}

@immutable
class GetSaleByBlNumberSalesBranch {
  final String id;
  final String name;
  GetSaleByBlNumberSalesBranch.fromJson(dynamic json):
  
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

    final GetSaleByBlNumberSalesBranch otherTyped = other as GetSaleByBlNumberSalesBranch;
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

  GetSaleByBlNumberSalesBranch({
    required this.id,
    required this.name,
  });
}

@immutable
class GetSaleByBlNumberSalesStockItem {
  final String id;
  final String serialNo;
  final GetSaleByBlNumberSalesStockItemProduct product;
  GetSaleByBlNumberSalesStockItem.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  product = GetSaleByBlNumberSalesStockItemProduct.fromJson(json['product']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSaleByBlNumberSalesStockItem otherTyped = other as GetSaleByBlNumberSalesStockItem;
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

  GetSaleByBlNumberSalesStockItem({
    required this.id,
    required this.serialNo,
    required this.product,
  });
}

@immutable
class GetSaleByBlNumberSalesStockItemProduct {
  final String productName;
  final String modelNo;
  GetSaleByBlNumberSalesStockItemProduct.fromJson(dynamic json):
  
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

    final GetSaleByBlNumberSalesStockItemProduct otherTyped = other as GetSaleByBlNumberSalesStockItemProduct;
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

  GetSaleByBlNumberSalesStockItemProduct({
    required this.productName,
    required this.modelNo,
  });
}

@immutable
class GetSaleByBlNumberData {
  final List<GetSaleByBlNumberSales> sales;
  GetSaleByBlNumberData.fromJson(dynamic json):
  
  sales = (json['sales'] as List<dynamic>)
        .map((e) => GetSaleByBlNumberSales.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSaleByBlNumberData otherTyped = other as GetSaleByBlNumberData;
    return sales == otherTyped.sales;
    
  }
  @override
  int get hashCode => sales.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sales'] = sales.map((e) => e.toJson()).toList();
    return json;
  }

  GetSaleByBlNumberData({
    required this.sales,
  });
}

@immutable
class GetSaleByBlNumberVariables {
  final String blNumber;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetSaleByBlNumberVariables.fromJson(Map<String, dynamic> json):
  
  blNumber = nativeFromJson<String>(json['blNumber']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetSaleByBlNumberVariables otherTyped = other as GetSaleByBlNumberVariables;
    return blNumber == otherTyped.blNumber;
    
  }
  @override
  int get hashCode => blNumber.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['blNumber'] = nativeToJson<String>(blNumber);
    return json;
  }

  GetSaleByBlNumberVariables({
    required this.blNumber,
  });
}

