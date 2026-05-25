part of 'generated.dart';

class GetActiveBillsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetActiveBillsVariablesBuilder(this._dataConnect, );
  Deserializer<GetActiveBillsData> dataDeserializer = (dynamic json)  => GetActiveBillsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetActiveBillsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetActiveBillsData, void> ref() {
    
    return _dataConnect.query("GetActiveBills", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetActiveBillsEasyPaymentBills {
  final String id;
  final String billNumber;
  final double currentBalance;
  final int remainingMonths;
  final double monthlyInstallment;
  final String status;
  GetActiveBillsEasyPaymentBills.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  billNumber = nativeFromJson<String>(json['billNumber']),
  currentBalance = nativeFromJson<double>(json['currentBalance']),
  remainingMonths = nativeFromJson<int>(json['remainingMonths']),
  monthlyInstallment = nativeFromJson<double>(json['monthlyInstallment']),
  status = nativeFromJson<String>(json['status']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBillsEasyPaymentBills otherTyped = other as GetActiveBillsEasyPaymentBills;
    return id == otherTyped.id && 
    billNumber == otherTyped.billNumber && 
    currentBalance == otherTyped.currentBalance && 
    remainingMonths == otherTyped.remainingMonths && 
    monthlyInstallment == otherTyped.monthlyInstallment && 
    status == otherTyped.status;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, billNumber.hashCode, currentBalance.hashCode, remainingMonths.hashCode, monthlyInstallment.hashCode, status.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['billNumber'] = nativeToJson<String>(billNumber);
    json['currentBalance'] = nativeToJson<double>(currentBalance);
    json['remainingMonths'] = nativeToJson<int>(remainingMonths);
    json['monthlyInstallment'] = nativeToJson<double>(monthlyInstallment);
    json['status'] = nativeToJson<String>(status);
    return json;
  }

  GetActiveBillsEasyPaymentBills({
    required this.id,
    required this.billNumber,
    required this.currentBalance,
    required this.remainingMonths,
    required this.monthlyInstallment,
    required this.status,
  });
}

@immutable
class GetActiveBillsData {
  final List<GetActiveBillsEasyPaymentBills> easyPaymentBills;
  GetActiveBillsData.fromJson(dynamic json):
  
  easyPaymentBills = (json['easyPaymentBills'] as List<dynamic>)
        .map((e) => GetActiveBillsEasyPaymentBills.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetActiveBillsData otherTyped = other as GetActiveBillsData;
    return easyPaymentBills == otherTyped.easyPaymentBills;
    
  }
  @override
  int get hashCode => easyPaymentBills.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['easyPaymentBills'] = easyPaymentBills.map((e) => e.toJson()).toList();
    return json;
  }

  GetActiveBillsData({
    required this.easyPaymentBills,
  });
}

