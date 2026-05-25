part of 'generated.dart';

class UpsertCustomerPhotoVariablesBuilder {
  String id;
  String customerId;
  String photoType;
  Optional<String> _remoteUrl = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;

  final FirebaseDataConnect _dataConnect;  UpsertCustomerPhotoVariablesBuilder remoteUrl(String? t) {
   _remoteUrl.value = t;
   return this;
  }

  UpsertCustomerPhotoVariablesBuilder(this._dataConnect, {required  this.id,required  this.customerId,required  this.photoType,required  this.createdAt,});
  Deserializer<UpsertCustomerPhotoData> dataDeserializer = (dynamic json)  => UpsertCustomerPhotoData.fromJson(jsonDecode(json));
  Serializer<UpsertCustomerPhotoVariables> varsSerializer = (UpsertCustomerPhotoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertCustomerPhotoData, UpsertCustomerPhotoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertCustomerPhotoData, UpsertCustomerPhotoVariables> ref() {
    UpsertCustomerPhotoVariables vars= UpsertCustomerPhotoVariables(id: id,customerId: customerId,photoType: photoType,remoteUrl: _remoteUrl,createdAt: createdAt,);
    return _dataConnect.mutation("UpsertCustomerPhoto", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertCustomerPhotoCustomerPhotoUpsert {
  final String id;
  UpsertCustomerPhotoCustomerPhotoUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerPhotoCustomerPhotoUpsert otherTyped = other as UpsertCustomerPhotoCustomerPhotoUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertCustomerPhotoCustomerPhotoUpsert({
    required this.id,
  });
}

@immutable
class UpsertCustomerPhotoData {
  final UpsertCustomerPhotoCustomerPhotoUpsert customerPhoto_upsert;
  UpsertCustomerPhotoData.fromJson(dynamic json):
  
  customerPhoto_upsert = UpsertCustomerPhotoCustomerPhotoUpsert.fromJson(json['customerPhoto_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerPhotoData otherTyped = other as UpsertCustomerPhotoData;
    return customerPhoto_upsert == otherTyped.customerPhoto_upsert;
    
  }
  @override
  int get hashCode => customerPhoto_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['customerPhoto_upsert'] = customerPhoto_upsert.toJson();
    return json;
  }

  UpsertCustomerPhotoData({
    required this.customerPhoto_upsert,
  });
}

@immutable
class UpsertCustomerPhotoVariables {
  final String id;
  final String customerId;
  final String photoType;
  late final Optional<String>remoteUrl;
  final double createdAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertCustomerPhotoVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  customerId = nativeFromJson<String>(json['customerId']),
  photoType = nativeFromJson<String>(json['photoType']),
  createdAt = nativeFromJson<double>(json['createdAt']) {
  
  
  
  
  
    remoteUrl = Optional.optional(nativeFromJson, nativeToJson);
    remoteUrl.value = json['remoteUrl'] == null ? null : nativeFromJson<String>(json['remoteUrl']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertCustomerPhotoVariables otherTyped = other as UpsertCustomerPhotoVariables;
    return id == otherTyped.id && 
    customerId == otherTyped.customerId && 
    photoType == otherTyped.photoType && 
    remoteUrl == otherTyped.remoteUrl && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, customerId.hashCode, photoType.hashCode, remoteUrl.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['customerId'] = nativeToJson<String>(customerId);
    json['photoType'] = nativeToJson<String>(photoType);
    if(remoteUrl.state == OptionalState.set) {
      json['remoteUrl'] = remoteUrl.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    return json;
  }

  UpsertCustomerPhotoVariables({
    required this.id,
    required this.customerId,
    required this.photoType,
    required this.remoteUrl,
    required this.createdAt,
  });
}

