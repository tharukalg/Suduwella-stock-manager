part of 'generated.dart';

class DeleteB2bOrderVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteB2bOrderVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteB2bOrderData> dataDeserializer = (dynamic json)  => DeleteB2bOrderData.fromJson(jsonDecode(json));
  Serializer<DeleteB2bOrderVariables> varsSerializer = (DeleteB2bOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteB2bOrderData, DeleteB2bOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteB2bOrderData, DeleteB2bOrderVariables> ref() {
    DeleteB2bOrderVariables vars= DeleteB2bOrderVariables(id: id,);
    return _dataConnect.mutation("DeleteB2bOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteB2bOrderB2bOrderDelete {
  final String id;
  DeleteB2bOrderB2bOrderDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderB2bOrderDelete otherTyped = other as DeleteB2bOrderB2bOrderDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteB2bOrderB2bOrderDelete({
    required this.id,
  });
}

@immutable
class DeleteB2bOrderData {
  final DeleteB2bOrderB2bOrderDelete? b2bOrder_delete;
  DeleteB2bOrderData.fromJson(dynamic json):
  
  b2bOrder_delete = json['b2bOrder_delete'] == null ? null : DeleteB2bOrderB2bOrderDelete.fromJson(json['b2bOrder_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderData otherTyped = other as DeleteB2bOrderData;
    return b2bOrder_delete == otherTyped.b2bOrder_delete;
    
  }
  @override
  int get hashCode => b2bOrder_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (b2bOrder_delete != null) {
      json['b2bOrder_delete'] = b2bOrder_delete!.toJson();
    }
    return json;
  }

  DeleteB2bOrderData({
    this.b2bOrder_delete,
  });
}

@immutable
class DeleteB2bOrderVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteB2bOrderVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderVariables otherTyped = other as DeleteB2bOrderVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteB2bOrderVariables({
    required this.id,
  });
}

