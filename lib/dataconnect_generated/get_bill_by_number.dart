part of 'generated.dart';

class GetBillByNumberVariablesBuilder {
  String billNumber;

  final FirebaseDataConnect _dataConnect;
  GetBillByNumberVariablesBuilder(this._dataConnect, {required  this.billNumber,});
  Deserializer<GetBillByNumberData> dataDeserializer = (dynamic json)  => GetBillByNumberData.fromJson(jsonDecode(json));
  Serializer<GetBillByNumberVariables> varsSerializer = (GetBillByNumberVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetBillByNumberData, GetBillByNumberVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetBillByNumberData, GetBillByNumberVariables> ref() {
    GetBillByNumberVariables vars= GetBillByNumberVariables(billNumber: billNumber,);
    return _dataConnect.query("GetBillByNumber", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetBillByNumberEasyPaymentBills {
  final String id;
  final String billNumber;
  final double currentBalance;
  final double totalPaid;
  final double? lastPaymentAmount;
  final double? lastPaymentDate;
  final int remainingMonths;
  final double monthlyInstallment;
  final bool isActive;
  final String status;
  final double createdAt;
  final GetBillByNumberEasyPaymentBillsSale? sale;
  GetBillByNumberEasyPaymentBills.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  billNumber = nativeFromJson<String>(json['billNumber']),
  currentBalance = nativeFromJson<double>(json['currentBalance']),
  totalPaid = nativeFromJson<double>(json['totalPaid']),
  lastPaymentAmount = json['lastPaymentAmount'] == null ? null : nativeFromJson<double>(json['lastPaymentAmount']),
  lastPaymentDate = json['lastPaymentDate'] == null ? null : nativeFromJson<double>(json['lastPaymentDate']),
  remainingMonths = nativeFromJson<int>(json['remainingMonths']),
  monthlyInstallment = nativeFromJson<double>(json['monthlyInstallment']),
  isActive = nativeFromJson<bool>(json['isActive']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  sale = json['sale'] == null ? null : GetBillByNumberEasyPaymentBillsSale.fromJson(json['sale']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBillByNumberEasyPaymentBills otherTyped = other as GetBillByNumberEasyPaymentBills;
    return id == otherTyped.id && 
    billNumber == otherTyped.billNumber && 
    currentBalance == otherTyped.currentBalance && 
    totalPaid == otherTyped.totalPaid && 
    lastPaymentAmount == otherTyped.lastPaymentAmount && 
    lastPaymentDate == otherTyped.lastPaymentDate && 
    remainingMonths == otherTyped.remainingMonths && 
    monthlyInstallment == otherTyped.monthlyInstallment && 
    isActive == otherTyped.isActive && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    sale == otherTyped.sale;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, billNumber.hashCode, currentBalance.hashCode, totalPaid.hashCode, lastPaymentAmount.hashCode, lastPaymentDate.hashCode, remainingMonths.hashCode, monthlyInstallment.hashCode, isActive.hashCode, status.hashCode, createdAt.hashCode, sale.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['billNumber'] = nativeToJson<String>(billNumber);
    json['currentBalance'] = nativeToJson<double>(currentBalance);
    json['totalPaid'] = nativeToJson<double>(totalPaid);
    if (lastPaymentAmount != null) {
      json['lastPaymentAmount'] = nativeToJson<double?>(lastPaymentAmount);
    }
    if (lastPaymentDate != null) {
      json['lastPaymentDate'] = nativeToJson<double?>(lastPaymentDate);
    }
    json['remainingMonths'] = nativeToJson<int>(remainingMonths);
    json['monthlyInstallment'] = nativeToJson<double>(monthlyInstallment);
    json['isActive'] = nativeToJson<bool>(isActive);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    if (sale != null) {
      json['sale'] = sale!.toJson();
    }
    return json;
  }

  GetBillByNumberEasyPaymentBills({
    required this.id,
    required this.billNumber,
    required this.currentBalance,
    required this.totalPaid,
    this.lastPaymentAmount,
    this.lastPaymentDate,
    required this.remainingMonths,
    required this.monthlyInstallment,
    required this.isActive,
    required this.status,
    required this.createdAt,
    this.sale,
  });
}

@immutable
class GetBillByNumberEasyPaymentBillsSale {
  final String id;
  final String blNumber;
  GetBillByNumberEasyPaymentBillsSale.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  blNumber = nativeFromJson<String>(json['blNumber']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBillByNumberEasyPaymentBillsSale otherTyped = other as GetBillByNumberEasyPaymentBillsSale;
    return id == otherTyped.id && 
    blNumber == otherTyped.blNumber;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, blNumber.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['blNumber'] = nativeToJson<String>(blNumber);
    return json;
  }

  GetBillByNumberEasyPaymentBillsSale({
    required this.id,
    required this.blNumber,
  });
}

@immutable
class GetBillByNumberData {
  final List<GetBillByNumberEasyPaymentBills> easyPaymentBills;
  GetBillByNumberData.fromJson(dynamic json):
  
  easyPaymentBills = (json['easyPaymentBills'] as List<dynamic>)
        .map((e) => GetBillByNumberEasyPaymentBills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBillByNumberData otherTyped = other as GetBillByNumberData;
    return easyPaymentBills == otherTyped.easyPaymentBills;
    
  }
  @override
  int get hashCode => easyPaymentBills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['easyPaymentBills'] = easyPaymentBills.map((e) => e.toJson()).toList();
    return json;
  }

  GetBillByNumberData({
    required this.easyPaymentBills,
  });
}

@immutable
class GetBillByNumberVariables {
  final String billNumber;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetBillByNumberVariables.fromJson(Map<String, dynamic> json):
  
  billNumber = nativeFromJson<String>(json['billNumber']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetBillByNumberVariables otherTyped = other as GetBillByNumberVariables;
    return billNumber == otherTyped.billNumber;
    
  }
  @override
  int get hashCode => billNumber.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['billNumber'] = nativeToJson<String>(billNumber);
    return json;
  }

  GetBillByNumberVariables({
    required this.billNumber,
  });
}

