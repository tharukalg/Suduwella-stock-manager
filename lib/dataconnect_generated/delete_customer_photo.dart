part of 'generated.dart';

class DeleteCustomerPhotoVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteCustomerPhotoVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteCustomerPhotoData> dataDeserializer = (dynamic json)  => DeleteCustomerPhotoData.fromJson(jsonDecode(json));
  Serializer<DeleteCustomerPhotoVariables> varsSerializer = (DeleteCustomerPhotoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteCustomerPhotoData, DeleteCustomerPhotoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteCustomerPhotoData, DeleteCustomerPhotoVariables> ref() {
    DeleteCustomerPhotoVariables vars= DeleteCustomerPhotoVariables(id: id,);
    return _dataConnect.mutation("DeleteCustomerPhoto", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteCustomerPhotoCustomerPhotoDelete {
  final String id;
  DeleteCustomerPhotoCustomerPhotoDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCustomerPhotoCustomerPhotoDelete otherTyped = other as DeleteCustomerPhotoCustomerPhotoDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCustomerPhotoCustomerPhotoDelete({
    required this.id,
  });
}

@immutable
class DeleteCustomerPhotoData {
  final DeleteCustomerPhotoCustomerPhotoDelete? customerPhoto_delete;
  DeleteCustomerPhotoData.fromJson(dynamic json):
  
  customerPhoto_delete = json['customerPhoto_delete'] == null ? null : DeleteCustomerPhotoCustomerPhotoDelete.fromJson(json['customerPhoto_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCustomerPhotoData otherTyped = other as DeleteCustomerPhotoData;
    return customerPhoto_delete == otherTyped.customerPhoto_delete;
    
  }
  @override
  int get hashCode => customerPhoto_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (customerPhoto_delete != null) {
      json['customerPhoto_delete'] = customerPhoto_delete!.toJson();
    }
    return json;
  }

  DeleteCustomerPhotoData({
    this.customerPhoto_delete,
  });
}

@immutable
class DeleteCustomerPhotoVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteCustomerPhotoVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCustomerPhotoVariables otherTyped = other as DeleteCustomerPhotoVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCustomerPhotoVariables({
    required this.id,
  });
}

