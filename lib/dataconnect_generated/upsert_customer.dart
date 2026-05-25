part of 'generated.dart';

class UpsertCustomerVariablesBuilder {
  String id;
  String nic;
  String name;
  String phone;
  Optional<String> _description = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertCustomerVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  UpsertCustomerVariablesBuilder(this._dataConnect, {required  this.id,required  this.nic,required  this.name,required  this.phone,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertCustomerData> dataDeserializer = (dynamic json)  => UpsertCustomerData.fromJson(jsonDecode(json));
  Serializer<UpsertCustomerVariables> varsSerializer = (UpsertCustomerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCustomerData, UpsertCustomerVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCustomerData, UpsertCustomerVariables> ref() {
    UpsertCustomerVariables vars= UpsertCustomerVariables(id: id,nic: nic,name: name,phone: phone,description: _description,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertCustomer", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCustomerCustomerUpsert {
  final String id;
  UpsertCustomerCustomerUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerCustomerUpsert otherTyped = other as UpsertCustomerCustomerUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCustomerCustomerUpsert({
    required this.id,
  });
}

@immutable
class UpsertCustomerData {
  final UpsertCustomerCustomerUpsert customer_upsert;
  UpsertCustomerData.fromJson(dynamic json):
  
  customer_upsert = UpsertCustomerCustomerUpsert.fromJson(json['customer_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerData otherTyped = other as UpsertCustomerData;
    return customer_upsert == otherTyped.customer_upsert;
    
  }
  @override
  int get hashCode => customer_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['customer_upsert'] = customer_upsert.toJson();
    return json;
  }

  UpsertCustomerData({
    required this.customer_upsert,
  });
}

@immutable
class UpsertCustomerVariables {
  final String id;
  final String nic;
  final String name;
  final String phone;
  late final Optional<String>description;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCustomerVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  nic = nativeFromJson<String>(json['nic']),
  name = nativeFromJson<String>(json['name']),
  phone = nativeFromJson<String>(json['phone']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
  
  
  
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerVariables otherTyped = other as UpsertCustomerVariables;
    return id == otherTyped.id && 
    nic == otherTyped.nic && 
    name == otherTyped.name && 
    phone == otherTyped.phone && 
    description == otherTyped.description && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nic.hashCode, name.hashCode, phone.hashCode, description.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nic'] = nativeToJson<String>(nic);
    json['name'] = nativeToJson<String>(name);
    json['phone'] = nativeToJson<String>(phone);
    if(description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertCustomerVariables({
    required this.id,
    required this.nic,
    required this.name,
    required this.phone,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}

