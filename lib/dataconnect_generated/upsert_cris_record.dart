part of 'generated.dart';

class UpsertCrisRecordVariablesBuilder {
  String id;
  Optional<String> _customerId = Optional.optional(nativeFromJson, nativeToJson);
  String dNumber;
  String bNumber;
  double balance;
  String status;
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertCrisRecordVariablesBuilder customerId(String? t) {
   _customerId.value = t;
   return this;
  }

  UpsertCrisRecordVariablesBuilder(this._dataConnect, {required  this.id,required  this.dNumber,required  this.bNumber,required  this.balance,required  this.status,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertCrisRecordData> dataDeserializer = (dynamic json)  => UpsertCrisRecordData.fromJson(jsonDecode(json));
  Serializer<UpsertCrisRecordVariables> varsSerializer = (UpsertCrisRecordVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCrisRecordData, UpsertCrisRecordVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCrisRecordData, UpsertCrisRecordVariables> ref() {
    UpsertCrisRecordVariables vars= UpsertCrisRecordVariables(id: id,customerId: _customerId,dNumber: dNumber,bNumber: bNumber,balance: balance,status: status,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertCrisRecord", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCrisRecordCrisRecordUpsert {
  final String id;
  UpsertCrisRecordCrisRecordUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCrisRecordCrisRecordUpsert otherTyped = other as UpsertCrisRecordCrisRecordUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCrisRecordCrisRecordUpsert({
    required this.id,
  });
}

@immutable
class UpsertCrisRecordData {
  final UpsertCrisRecordCrisRecordUpsert crisRecord_upsert;
  UpsertCrisRecordData.fromJson(dynamic json):
  
  crisRecord_upsert = UpsertCrisRecordCrisRecordUpsert.fromJson(json['crisRecord_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCrisRecordData otherTyped = other as UpsertCrisRecordData;
    return crisRecord_upsert == otherTyped.crisRecord_upsert;
    
  }
  @override
  int get hashCode => crisRecord_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['crisRecord_upsert'] = crisRecord_upsert.toJson();
    return json;
  }

  UpsertCrisRecordData({
    required this.crisRecord_upsert,
  });
}

@immutable
class UpsertCrisRecordVariables {
  final String id;
  late final Optional<String>customerId;
  final String dNumber;
  final String bNumber;
  final double balance;
  final String status;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCrisRecordVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  dNumber = nativeFromJson<String>(json['dNumber']),
  bNumber = nativeFromJson<String>(json['bNumber']),
  balance = nativeFromJson<double>(json['balance']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
    customerId = Optional.optional(nativeFromJson, nativeToJson);
    customerId.value = json['customerId'] == null ? null : nativeFromJson<String>(json['customerId']);
  
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCrisRecordVariables otherTyped = other as UpsertCrisRecordVariables;
    return id == otherTyped.id && 
    customerId == otherTyped.customerId && 
    dNumber == otherTyped.dNumber && 
    bNumber == otherTyped.bNumber && 
    balance == otherTyped.balance && 
    status == otherTyped.status && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, customerId.hashCode, dNumber.hashCode, bNumber.hashCode, balance.hashCode, status.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if(customerId.state == OptionalState.set) {
      json['customerId'] = customerId.toJson();
    }
    json['dNumber'] = nativeToJson<String>(dNumber);
    json['bNumber'] = nativeToJson<String>(bNumber);
    json['balance'] = nativeToJson<double>(balance);
    json['status'] = nativeToJson<String>(status);
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertCrisRecordVariables({
    required this.id,
    required this.customerId,
    required this.dNumber,
    required this.bNumber,
    required this.balance,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}

