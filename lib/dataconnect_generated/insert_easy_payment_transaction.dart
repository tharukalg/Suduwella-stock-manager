part of 'generated.dart';

class InsertEasyPaymentTransactionVariablesBuilder {
  String id;
  String billId;
  String transactionType;
  Optional<double> _amount = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _remainingMonths = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _newMonthlyInstallment = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  String branchCode;
  double createdAt;

  final FirebaseDataConnect _dataConnect;  InsertEasyPaymentTransactionVariablesBuilder amount(double? t) {
   _amount.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder remainingMonths(int? t) {
   _remainingMonths.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder newMonthlyInstallment(double? t) {
   _newMonthlyInstallment.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  InsertEasyPaymentTransactionVariablesBuilder(this._dataConnect, {required  this.id,required  this.billId,required  this.transactionType,required  this.branchCode,required  this.createdAt,});
  Deserializer<InsertEasyPaymentTransactionData> dataDeserializer = (dynamic json)  => InsertEasyPaymentTransactionData.fromJson(jsonDecode(json));
  Serializer<InsertEasyPaymentTransactionVariables> varsSerializer = (InsertEasyPaymentTransactionVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertEasyPaymentTransactionData, InsertEasyPaymentTransactionVariables>> execute() {
    return ref().execute();
  }

  MutationRef<InsertEasyPaymentTransactionData, InsertEasyPaymentTransactionVariables> ref() {
    InsertEasyPaymentTransactionVariables vars= InsertEasyPaymentTransactionVariables(id: id,billId: billId,transactionType: transactionType,amount: _amount,remainingMonths: _remainingMonths,newMonthlyInstallment: _newMonthlyInstallment,notes: _notes,branchCode: branchCode,createdAt: createdAt,);
    return _dataConnect.mutation("InsertEasyPaymentTransaction", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class InsertEasyPaymentTransactionEasyPaymentTransactionInsert {
  final String id;
  InsertEasyPaymentTransactionEasyPaymentTransactionInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertEasyPaymentTransactionEasyPaymentTransactionInsert otherTyped = other as InsertEasyPaymentTransactionEasyPaymentTransactionInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertEasyPaymentTransactionEasyPaymentTransactionInsert({
    required this.id,
  });
}

@immutable
class InsertEasyPaymentTransactionData {
  final InsertEasyPaymentTransactionEasyPaymentTransactionInsert easyPaymentTransaction_insert;
  InsertEasyPaymentTransactionData.fromJson(dynamic json):
  
  easyPaymentTransaction_insert = InsertEasyPaymentTransactionEasyPaymentTransactionInsert.fromJson(json['easyPaymentTransaction_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertEasyPaymentTransactionData otherTyped = other as InsertEasyPaymentTransactionData;
    return easyPaymentTransaction_insert == otherTyped.easyPaymentTransaction_insert;
    
  }
  @override
  int get hashCode => easyPaymentTransaction_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['easyPaymentTransaction_insert'] = easyPaymentTransaction_insert.toJson();
    return json;
  }

  InsertEasyPaymentTransactionData({
    required this.easyPaymentTransaction_insert,
  });
}

@immutable
class InsertEasyPaymentTransactionVariables {
  final String id;
  final String billId;
  final String transactionType;
  late final Optional<double>amount;
  late final Optional<int>remainingMonths;
  late final Optional<double>newMonthlyInstallment;
  late final Optional<String>notes;
  final String branchCode;
  final double createdAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  InsertEasyPaymentTransactionVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  billId = nativeFromJson<String>(json['billId']),
  transactionType = nativeFromJson<String>(json['transactionType']),
  branchCode = nativeFromJson<String>(json['branchCode']),
  createdAt = nativeFromJson<double>(json['createdAt']) {
  
  
  
  
  
    amount = Optional.optional(nativeFromJson, nativeToJson);
    amount.value = json['amount'] == null ? null : nativeFromJson<double>(json['amount']);
  
  
    remainingMonths = Optional.optional(nativeFromJson, nativeToJson);
    remainingMonths.value = json['remainingMonths'] == null ? null : nativeFromJson<int>(json['remainingMonths']);
  
  
    newMonthlyInstallment = Optional.optional(nativeFromJson, nativeToJson);
    newMonthlyInstallment.value = json['newMonthlyInstallment'] == null ? null : nativeFromJson<double>(json['newMonthlyInstallment']);
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertEasyPaymentTransactionVariables otherTyped = other as InsertEasyPaymentTransactionVariables;
    return id == otherTyped.id && 
    billId == otherTyped.billId && 
    transactionType == otherTyped.transactionType && 
    amount == otherTyped.amount && 
    remainingMonths == otherTyped.remainingMonths && 
    newMonthlyInstallment == otherTyped.newMonthlyInstallment && 
    notes == otherTyped.notes && 
    branchCode == otherTyped.branchCode && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, billId.hashCode, transactionType.hashCode, amount.hashCode, remainingMonths.hashCode, newMonthlyInstallment.hashCode, notes.hashCode, branchCode.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['billId'] = nativeToJson<String>(billId);
    json['transactionType'] = nativeToJson<String>(transactionType);
    if(amount.state == OptionalState.set) {
      json['amount'] = amount.toJson();
    }
    if(remainingMonths.state == OptionalState.set) {
      json['remainingMonths'] = remainingMonths.toJson();
    }
    if(newMonthlyInstallment.state == OptionalState.set) {
      json['newMonthlyInstallment'] = newMonthlyInstallment.toJson();
    }
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['branchCode'] = nativeToJson<String>(branchCode);
    json['createdAt'] = nativeToJson<double>(createdAt);
    return json;
  }

  InsertEasyPaymentTransactionVariables({
    required this.id,
    required this.billId,
    required this.transactionType,
    required this.amount,
    required this.remainingMonths,
    required this.newMonthlyInstallment,
    required this.notes,
    required this.branchCode,
    required this.createdAt,
  });
}

