part of 'generated.dart';

class UpsertEasyPaymentBillVariablesBuilder {
  String id;
  String billNumber;
  Optional<String> _saleId = Optional.optional(nativeFromJson, nativeToJson);
  double currentBalance;
  double totalPaid;
  Optional<double> _lastPaymentAmount = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _lastPaymentDate = Optional.optional(nativeFromJson, nativeToJson);
  int remainingMonths;
  double monthlyInstallment;
  bool isActive;
  String status;
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertEasyPaymentBillVariablesBuilder saleId(String? t) {
   _saleId.value = t;
   return this;
  }
  UpsertEasyPaymentBillVariablesBuilder lastPaymentAmount(double? t) {
   _lastPaymentAmount.value = t;
   return this;
  }
  UpsertEasyPaymentBillVariablesBuilder lastPaymentDate(double? t) {
   _lastPaymentDate.value = t;
   return this;
  }

  UpsertEasyPaymentBillVariablesBuilder(this._dataConnect, {required  this.id,required  this.billNumber,required  this.currentBalance,required  this.totalPaid,required  this.remainingMonths,required  this.monthlyInstallment,required  this.isActive,required  this.status,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertEasyPaymentBillData> dataDeserializer = (dynamic json)  => UpsertEasyPaymentBillData.fromJson(jsonDecode(json));
  Serializer<UpsertEasyPaymentBillVariables> varsSerializer = (UpsertEasyPaymentBillVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertEasyPaymentBillData, UpsertEasyPaymentBillVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertEasyPaymentBillData, UpsertEasyPaymentBillVariables> ref() {
    UpsertEasyPaymentBillVariables vars= UpsertEasyPaymentBillVariables(id: id,billNumber: billNumber,saleId: _saleId,currentBalance: currentBalance,totalPaid: totalPaid,lastPaymentAmount: _lastPaymentAmount,lastPaymentDate: _lastPaymentDate,remainingMonths: remainingMonths,monthlyInstallment: monthlyInstallment,isActive: isActive,status: status,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertEasyPaymentBill", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertEasyPaymentBillEasyPaymentBillUpsert {
  final String id;
  UpsertEasyPaymentBillEasyPaymentBillUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertEasyPaymentBillEasyPaymentBillUpsert otherTyped = other as UpsertEasyPaymentBillEasyPaymentBillUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertEasyPaymentBillEasyPaymentBillUpsert({
    required this.id,
  });
}

@immutable
class UpsertEasyPaymentBillData {
  final UpsertEasyPaymentBillEasyPaymentBillUpsert easyPaymentBill_upsert;
  UpsertEasyPaymentBillData.fromJson(dynamic json):
  
  easyPaymentBill_upsert = UpsertEasyPaymentBillEasyPaymentBillUpsert.fromJson(json['easyPaymentBill_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertEasyPaymentBillData otherTyped = other as UpsertEasyPaymentBillData;
    return easyPaymentBill_upsert == otherTyped.easyPaymentBill_upsert;
    
  }
  @override
  int get hashCode => easyPaymentBill_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['easyPaymentBill_upsert'] = easyPaymentBill_upsert.toJson();
    return json;
  }

  UpsertEasyPaymentBillData({
    required this.easyPaymentBill_upsert,
  });
}

@immutable
class UpsertEasyPaymentBillVariables {
  final String id;
  final String billNumber;
  late final Optional<String>saleId;
  final double currentBalance;
  final double totalPaid;
  late final Optional<double>lastPaymentAmount;
  late final Optional<double>lastPaymentDate;
  final int remainingMonths;
  final double monthlyInstallment;
  final bool isActive;
  final String status;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertEasyPaymentBillVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  billNumber = nativeFromJson<String>(json['billNumber']),
  currentBalance = nativeFromJson<double>(json['currentBalance']),
  totalPaid = nativeFromJson<double>(json['totalPaid']),
  remainingMonths = nativeFromJson<int>(json['remainingMonths']),
  monthlyInstallment = nativeFromJson<double>(json['monthlyInstallment']),
  isActive = nativeFromJson<bool>(json['isActive']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
  
    saleId = Optional.optional(nativeFromJson, nativeToJson);
    saleId.value = json['saleId'] == null ? null : nativeFromJson<String>(json['saleId']);
  
  
  
  
    lastPaymentAmount = Optional.optional(nativeFromJson, nativeToJson);
    lastPaymentAmount.value = json['lastPaymentAmount'] == null ? null : nativeFromJson<double>(json['lastPaymentAmount']);
  
  
    lastPaymentDate = Optional.optional(nativeFromJson, nativeToJson);
    lastPaymentDate.value = json['lastPaymentDate'] == null ? null : nativeFromJson<double>(json['lastPaymentDate']);
  
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertEasyPaymentBillVariables otherTyped = other as UpsertEasyPaymentBillVariables;
    return id == otherTyped.id && 
    billNumber == otherTyped.billNumber && 
    saleId == otherTyped.saleId && 
    currentBalance == otherTyped.currentBalance && 
    totalPaid == otherTyped.totalPaid && 
    lastPaymentAmount == otherTyped.lastPaymentAmount && 
    lastPaymentDate == otherTyped.lastPaymentDate && 
    remainingMonths == otherTyped.remainingMonths && 
    monthlyInstallment == otherTyped.monthlyInstallment && 
    isActive == otherTyped.isActive && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, billNumber.hashCode, saleId.hashCode, currentBalance.hashCode, totalPaid.hashCode, lastPaymentAmount.hashCode, lastPaymentDate.hashCode, remainingMonths.hashCode, monthlyInstallment.hashCode, isActive.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['billNumber'] = nativeToJson<String>(billNumber);
    if(saleId.state == OptionalState.set) {
      json['saleId'] = saleId.toJson();
    }
    json['currentBalance'] = nativeToJson<double>(currentBalance);
    json['totalPaid'] = nativeToJson<double>(totalPaid);
    if(lastPaymentAmount.state == OptionalState.set) {
      json['lastPaymentAmount'] = lastPaymentAmount.toJson();
    }
    if(lastPaymentDate.state == OptionalState.set) {
      json['lastPaymentDate'] = lastPaymentDate.toJson();
    }
    json['remainingMonths'] = nativeToJson<int>(remainingMonths);
    json['monthlyInstallment'] = nativeToJson<double>(monthlyInstallment);
    json['isActive'] = nativeToJson<bool>(isActive);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertEasyPaymentBillVariables({
    required this.id,
    required this.billNumber,
    required this.saleId,
    required this.currentBalance,
    required this.totalPaid,
    required this.lastPaymentAmount,
    required this.lastPaymentDate,
    required this.remainingMonths,
    required this.monthlyInstallment,
    required this.isActive,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

