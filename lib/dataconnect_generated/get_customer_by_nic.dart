part of 'generated.dart';

class GetCustomerByNicVariablesBuilder {
  String nic;

  final FirebaseDataConnect _dataConnect;
  GetCustomerByNicVariablesBuilder(this._dataConnect, {required  this.nic,});
  Deserializer<GetCustomerByNicData> dataDeserializer = (dynamic json)  => GetCustomerByNicData.fromJson(jsonDecode(json));
  Serializer<GetCustomerByNicVariables> varsSerializer = (GetCustomerByNicVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetCustomerByNicData, GetCustomerByNicVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetCustomerByNicData, GetCustomerByNicVariables> ref() {
    GetCustomerByNicVariables vars= GetCustomerByNicVariables(nic: nic,);
    return _dataConnect.query("GetCustomerByNic", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetCustomerByNicCustomers {
  final String id;
  final String nic;
  final String name;
  final String phone;
  final String? description;
  final double createdAt;
  GetCustomerByNicCustomers.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nic = nativeFromJson<String>(json['nic']),
  name = nativeFromJson<String>(json['name']),
  phone = nativeFromJson<String>(json['phone']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  createdAt = nativeFromJson<double>(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByNicCustomers otherTyped = other as GetCustomerByNicCustomers;
    return id == otherTyped.id && 
    nic == otherTyped.nic && 
    name == otherTyped.name && 
    phone == otherTyped.phone && 
    description == otherTyped.description && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nic.hashCode, name.hashCode, phone.hashCode, description.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nic'] = nativeToJson<String>(nic);
    json['name'] = nativeToJson<String>(name);
    json['phone'] = nativeToJson<String>(phone);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    return json;
  }

  GetCustomerByNicCustomers({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    this.description,
    required this.createdAt,
  });
}

@immutable
class GetCustomerByNicData {
  final List<GetCustomerByNicCustomers> customers;
  GetCustomerByNicData.fromJson(dynamic json):
  
  customers = (json['customers'] as List<dynamic>)
        .map((e) => GetCustomerByNicCustomers.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByNicData otherTyped = other as GetCustomerByNicData;
    return customers == otherTyped.customers;
    
  }
  @override
  int get hashCode => customers.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['customers'] = customers.map((e) => e.toJson()).toList();
    return json;
  }

  GetCustomerByNicData({
    required this.customers,
  });
}

@immutable
class GetCustomerByNicVariables {
  final String nic;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetCustomerByNicVariables.fromJson(Map<String, dynamic> json):
  
  nic = nativeFromJson<String>(json['nic']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetCustomerByNicVariables otherTyped = other as GetCustomerByNicVariables;
    return nic == otherTyped.nic;
    
  }
  @override
  int get hashCode => nic.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['nic'] = nativeToJson<String>(nic);
    return json;
  }

  GetCustomerByNicVariables({
    required this.nic,
  });
}

