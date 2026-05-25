part of 'generated.dart';

class UpsertSaleVariablesBuilder {
  String id;
  String blNumber;
  String branchCode;
  String stockItemId;
  String paymentPlan;
  double downPayment;
  double totalAmount;
  double financedAmount;
  Optional<int> _durationMonths = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _monthlyInstallment = Optional.optional(nativeFromJson, nativeToJson);
  String status;
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertSaleVariablesBuilder durationMonths(int? t) {
   _durationMonths.value = t;
   return this;
  }
  UpsertSaleVariablesBuilder monthlyInstallment(double? t) {
   _monthlyInstallment.value = t;
   return this;
  }

  UpsertSaleVariablesBuilder(this._dataConnect, {required  this.id,required  this.blNumber,required  this.branchCode,required  this.stockItemId,required  this.paymentPlan,required  this.downPayment,required  this.totalAmount,required  this.financedAmount,required  this.status,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertSaleData> dataDeserializer = (dynamic json)  => UpsertSaleData.fromJson(jsonDecode(json));
  Serializer<UpsertSaleVariables> varsSerializer = (UpsertSaleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertSaleData, UpsertSaleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertSaleData, UpsertSaleVariables> ref() {
    UpsertSaleVariables vars= UpsertSaleVariables(id: id,blNumber: blNumber,branchCode: branchCode,stockItemId: stockItemId,paymentPlan: paymentPlan,downPayment: downPayment,totalAmount: totalAmount,financedAmount: financedAmount,durationMonths: _durationMonths,monthlyInstallment: _monthlyInstallment,status: status,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertSale", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertSaleSaleUpsert {
  final String id;
  UpsertSaleSaleUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleSaleUpsert otherTyped = other as UpsertSaleSaleUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertSaleSaleUpsert({
    required this.id,
  });
}

@immutable
class UpsertSaleData {
  final UpsertSaleSaleUpsert sale_upsert;
  UpsertSaleData.fromJson(dynamic json):
  
  sale_upsert = UpsertSaleSaleUpsert.fromJson(json['sale_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleData otherTyped = other as UpsertSaleData;
    return sale_upsert == otherTyped.sale_upsert;
    
  }
  @override
  int get hashCode => sale_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['sale_upsert'] = sale_upsert.toJson();
    return json;
  }

  UpsertSaleData({
    required this.sale_upsert,
  });
}

@immutable
class UpsertSaleVariables {
  final String id;
  final String blNumber;
  final String branchCode;
  final String stockItemId;
  final String paymentPlan;
  final double downPayment;
  final double totalAmount;
  final double financedAmount;
  late final Optional<int>durationMonths;
  late final Optional<double>monthlyInstallment;
  final String status;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertSaleVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  blNumber = nativeFromJson<String>(json['blNumber']),
  branchCode = nativeFromJson<String>(json['branchCode']),
  stockItemId = nativeFromJson<String>(json['stockItemId']),
  paymentPlan = nativeFromJson<String>(json['paymentPlan']),
  downPayment = nativeFromJson<double>(json['downPayment']),
  totalAmount = nativeFromJson<double>(json['totalAmount']),
  financedAmount = nativeFromJson<double>(json['financedAmount']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
  
  
  
  
  
  
  
    durationMonths = Optional.optional(nativeFromJson, nativeToJson);
    durationMonths.value = json['durationMonths'] == null ? null : nativeFromJson<int>(json['durationMonths']);
  
  
    monthlyInstallment = Optional.optional(nativeFromJson, nativeToJson);
    monthlyInstallment.value = json['monthlyInstallment'] == null ? null : nativeFromJson<double>(json['monthlyInstallment']);
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleVariables otherTyped = other as UpsertSaleVariables;
    return id == otherTyped.id && 
    blNumber == otherTyped.blNumber && 
    branchCode == otherTyped.branchCode && 
    stockItemId == otherTyped.stockItemId && 
    paymentPlan == otherTyped.paymentPlan && 
    downPayment == otherTyped.downPayment && 
    totalAmount == otherTyped.totalAmount && 
    financedAmount == otherTyped.financedAmount && 
    durationMonths == otherTyped.durationMonths && 
    monthlyInstallment == otherTyped.monthlyInstallment && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, blNumber.hashCode, branchCode.hashCode, stockItemId.hashCode, paymentPlan.hashCode, downPayment.hashCode, totalAmount.hashCode, financedAmount.hashCode, durationMonths.hashCode, monthlyInstallment.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['blNumber'] = nativeToJson<String>(blNumber);
    json['branchCode'] = nativeToJson<String>(branchCode);
    json['stockItemId'] = nativeToJson<String>(stockItemId);
    json['paymentPlan'] = nativeToJson<String>(paymentPlan);
    json['downPayment'] = nativeToJson<double>(downPayment);
    json['totalAmount'] = nativeToJson<double>(totalAmount);
    json['financedAmount'] = nativeToJson<double>(financedAmount);
    if(durationMonths.state == OptionalState.set) {
      json['durationMonths'] = durationMonths.toJson();
    }
    if(monthlyInstallment.state == OptionalState.set) {
      json['monthlyInstallment'] = monthlyInstallment.toJson();
    }
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertSaleVariables({
    required this.id,
    required this.blNumber,
    required this.branchCode,
    required this.stockItemId,
    required this.paymentPlan,
    required this.downPayment,
    required this.totalAmount,
    required this.financedAmount,
    required this.durationMonths,
    required this.monthlyInstallment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

