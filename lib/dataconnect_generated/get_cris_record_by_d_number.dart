part of 'generated.dart';

class GetCrisRecordByDNumberVariablesBuilder {
  String dNumber;

  final FirebaseDataConnect _dataConnect;
  GetCrisRecordByDNumberVariablesBuilder(this._dataConnect, {required  this.dNumber,});
  Deserializer<GetCrisRecordByDNumberData> dataDeserializer = (dynamic json)  => GetCrisRecordByDNumberData.fromJson(jsonDecode(json));
  Serializer<GetCrisRecordByDNumberVariables> varsSerializer = (GetCrisRecordByDNumberVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetCrisRecordByDNumberData, GetCrisRecordByDNumberVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetCrisRecordByDNumberData, GetCrisRecordByDNumberVariables> ref() {
    GetCrisRecordByDNumberVariables vars= GetCrisRecordByDNumberVariables(dNumber: dNumber,);
    return _dataConnect.query("GetCrisRecordByDNumber", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetCrisRecordByDNumberCrisRecords {
  final String id;
  final String dNumber;
  final String bNumber;
  final double balance;
  final String status;
  final GetCrisRecordByDNumberCrisRecordsCustomer? customer;
  GetCrisRecordByDNumberCrisRecords.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  dNumber = nativeFromJson<String>(json['dNumber']),
  bNumber = nativeFromJson<String>(json['bNumber']),
  balance = nativeFromJson<double>(json['balance']),
  status = nativeFromJson<String>(json['status']),
  customer = json['customer'] == null ? null : GetCrisRecordByDNumberCrisRecordsCustomer.fromJson(json['customer']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCrisRecordByDNumberCrisRecords otherTyped = other as GetCrisRecordByDNumberCrisRecords;
    return id == otherTyped.id && 
    dNumber == otherTyped.dNumber && 
    bNumber == otherTyped.bNumber && 
    balance == otherTyped.balance && 
    status == otherTyped.status && 
    customer == otherTyped.customer;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, dNumber.hashCode, bNumber.hashCode, balance.hashCode, status.hashCode, customer.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['dNumber'] = nativeToJson<String>(dNumber);
    json['bNumber'] = nativeToJson<String>(bNumber);
    json['balance'] = nativeToJson<double>(balance);
    json['status'] = nativeToJson<String>(status);
    if (customer != null) {
      json['customer'] = customer!.toJson();
    }
    return json;
  }

  GetCrisRecordByDNumberCrisRecords({
    required this.id,
    required this.dNumber,
    required this.bNumber,
    required this.balance,
    required this.status,
    this.customer,
  });
}

@immutable
class GetCrisRecordByDNumberCrisRecordsCustomer {
  final String id;
  final String name;
  final String nic;
  final String phone;
  GetCrisRecordByDNumberCrisRecordsCustomer.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  nic = nativeFromJson<String>(json['nic']),
  phone = nativeFromJson<String>(json['phone']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCrisRecordByDNumberCrisRecordsCustomer otherTyped = other as GetCrisRecordByDNumberCrisRecordsCustomer;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    nic == otherTyped.nic && 
    phone == otherTyped.phone;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, nic.hashCode, phone.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['nic'] = nativeToJson<String>(nic);
    json['phone'] = nativeToJson<String>(phone);
    return json;
  }

  GetCrisRecordByDNumberCrisRecordsCustomer({
    required this.id,
    required this.name,
    required this.nic,
    required this.phone,
  });
}

@immutable
class GetCrisRecordByDNumberData {
  final List<GetCrisRecordByDNumberCrisRecords> crisRecords;
  GetCrisRecordByDNumberData.fromJson(dynamic json):
  
  crisRecords = (json['crisRecords'] as List<dynamic>)
        .map((e) => GetCrisRecordByDNumberCrisRecords.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCrisRecordByDNumberData otherTyped = other as GetCrisRecordByDNumberData;
    return crisRecords == otherTyped.crisRecords;
    
  }
  @override
  int get hashCode => crisRecords.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['crisRecords'] = crisRecords.map((e) => e.toJson()).toList();
    return json;
  }

  GetCrisRecordByDNumberData({
    required this.crisRecords,
  });
}

@immutable
class GetCrisRecordByDNumberVariables {
  final String dNumber;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetCrisRecordByDNumberVariables.fromJson(Map<String, dynamic> json):
  
  dNumber = nativeFromJson<String>(json['dNumber']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCrisRecordByDNumberVariables otherTyped = other as GetCrisRecordByDNumberVariables;
    return dNumber == otherTyped.dNumber;
    
  }
  @override
  int get hashCode => dNumber.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['dNumber'] = nativeToJson<String>(dNumber);
    return json;
  }

  GetCrisRecordByDNumberVariables({
    required this.dNumber,
  });
}

