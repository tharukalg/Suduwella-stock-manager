part of 'generated.dart';

class GetOverdueCrisRecordsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetOverdueCrisRecordsVariablesBuilder(this._dataConnect, );
  Deserializer<GetOverdueCrisRecordsData> dataDeserializer = (dynamic json)  => GetOverdueCrisRecordsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetOverdueCrisRecordsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetOverdueCrisRecordsData, void> ref() {
    
    return _dataConnect.query("GetOverdueCrisRecords", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetOverdueCrisRecordsCrisRecords {
  final String id;
  final String dNumber;
  final String bNumber;
  final double balance;
  final String status;
  final GetOverdueCrisRecordsCrisRecordsCustomer? customer;
  GetOverdueCrisRecordsCrisRecords.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  dNumber = nativeFromJson<String>(json['dNumber']),
  bNumber = nativeFromJson<String>(json['bNumber']),
  balance = nativeFromJson<double>(json['balance']),
  status = nativeFromJson<String>(json['status']),
  customer = json['customer'] == null ? null : GetOverdueCrisRecordsCrisRecordsCustomer.fromJson(json['customer']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOverdueCrisRecordsCrisRecords otherTyped = other as GetOverdueCrisRecordsCrisRecords;
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

  GetOverdueCrisRecordsCrisRecords({
    required this.id,
    required this.dNumber,
    required this.bNumber,
    required this.balance,
    required this.status,
    this.customer,
  });
}

@immutable
class GetOverdueCrisRecordsCrisRecordsCustomer {
  final String id;
  final String name;
  final String nic;
  final String phone;
  GetOverdueCrisRecordsCrisRecordsCustomer.fromJson(dynamic json):
  
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

    final GetOverdueCrisRecordsCrisRecordsCustomer otherTyped = other as GetOverdueCrisRecordsCrisRecordsCustomer;
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

  GetOverdueCrisRecordsCrisRecordsCustomer({
    required this.id,
    required this.name,
    required this.nic,
    required this.phone,
  });
}

@immutable
class GetOverdueCrisRecordsData {
  final List<GetOverdueCrisRecordsCrisRecords> crisRecords;
  GetOverdueCrisRecordsData.fromJson(dynamic json):
  
  crisRecords = (json['crisRecords'] as List<dynamic>)
        .map((e) => GetOverdueCrisRecordsCrisRecords.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetOverdueCrisRecordsData otherTyped = other as GetOverdueCrisRecordsData;
    return crisRecords == otherTyped.crisRecords;
    
  }
  @override
  int get hashCode => crisRecords.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['crisRecords'] = crisRecords.map((e) => e.toJson()).toList();
    return json;
  }

  GetOverdueCrisRecordsData({
    required this.crisRecords,
  });
}

