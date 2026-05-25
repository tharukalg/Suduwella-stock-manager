part of 'generated.dart';

class GetCustomerByPhoneVariablesBuilder {
  String phone;

  final FirebaseDataConnect _dataConnect;
  GetCustomerByPhoneVariablesBuilder(this._dataConnect, {required  this.phone,});
  Deserializer<GetCustomerByPhoneData> dataDeserializer = (dynamic json)  => GetCustomerByPhoneData.fromJson(jsonDecode(json));
  Serializer<GetCustomerByPhoneVariables> varsSerializer = (GetCustomerByPhoneVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetCustomerByPhoneData, GetCustomerByPhoneVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetCustomerByPhoneData, GetCustomerByPhoneVariables> ref() {
    GetCustomerByPhoneVariables vars= GetCustomerByPhoneVariables(phone: phone,);
    return _dataConnect.query("GetCustomerByPhone", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetCustomerByPhoneCustomers {
  final String id;
  final String nic;
  final String name;
  final String phone;
  final String? description;
  GetCustomerByPhoneCustomers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nic = nativeFromJson<String>(json['nic']),
  name = nativeFromJson<String>(json['name']),
  phone = nativeFromJson<String>(json['phone']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByPhoneCustomers otherTyped = other as GetCustomerByPhoneCustomers;
    return id == otherTyped.id && 
    nic == otherTyped.nic && 
    name == otherTyped.name && 
    phone == otherTyped.phone && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nic.hashCode, name.hashCode, phone.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nic'] = nativeToJson<String>(nic);
    json['name'] = nativeToJson<String>(name);
    json['phone'] = nativeToJson<String>(phone);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    return json;
  }

  GetCustomerByPhoneCustomers({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    this.description,
  });
}

@immutable
class GetCustomerByPhoneData {
  final List<GetCustomerByPhoneCustomers> customers;
  GetCustomerByPhoneData.fromJson(dynamic json):
  
  customers = (json['customers'] as List<dynamic>)
        .map((e) => GetCustomerByPhoneCustomers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByPhoneData otherTyped = other as GetCustomerByPhoneData;
    return customers == otherTyped.customers;
    
  }
  @override
  int get hashCode => customers.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['customers'] = customers.map((e) => e.toJson()).toList();
    return json;
  }

  GetCustomerByPhoneData({
    required this.customers,
  });
}

@immutable
class GetCustomerByPhoneVariables {
  final String phone;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetCustomerByPhoneVariables.fromJson(Map<String, dynamic> json):
  
  phone = nativeFromJson<String>(json['phone']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByPhoneVariables otherTyped = other as GetCustomerByPhoneVariables;
    return phone == otherTyped.phone;
    
  }
  @override
  int get hashCode => phone.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['phone'] = nativeToJson<String>(phone);
    return json;
  }

  GetCustomerByPhoneVariables({
    required this.phone,
  });
}

