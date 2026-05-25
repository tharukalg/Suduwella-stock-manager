part of 'generated.dart';

class DeleteB2bOrderItemVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteB2bOrderItemVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteB2bOrderItemData> dataDeserializer = (dynamic json)  => DeleteB2bOrderItemData.fromJson(jsonDecode(json));
  Serializer<DeleteB2bOrderItemVariables> varsSerializer = (DeleteB2bOrderItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteB2bOrderItemData, DeleteB2bOrderItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteB2bOrderItemData, DeleteB2bOrderItemVariables> ref() {
    DeleteB2bOrderItemVariables vars= DeleteB2bOrderItemVariables(id: id,);
    return _dataConnect.mutation("DeleteB2bOrderItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteB2bOrderItemB2bOrderItemDelete {
  final String id;
  DeleteB2bOrderItemB2bOrderItemDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderItemB2bOrderItemDelete otherTyped = other as DeleteB2bOrderItemB2bOrderItemDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteB2bOrderItemB2bOrderItemDelete({
    required this.id,
  });
}

@immutable
class DeleteB2bOrderItemData {
  final DeleteB2bOrderItemB2bOrderItemDelete? b2bOrderItem_delete;
  DeleteB2bOrderItemData.fromJson(dynamic json):
  
  b2bOrderItem_delete = json['b2bOrderItem_delete'] == null ? null : DeleteB2bOrderItemB2bOrderItemDelete.fromJson(json['b2bOrderItem_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderItemData otherTyped = other as DeleteB2bOrderItemData;
    return b2bOrderItem_delete == otherTyped.b2bOrderItem_delete;
    
  }
  @override
  int get hashCode => b2bOrderItem_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (b2bOrderItem_delete != null) {
      json['b2bOrderItem_delete'] = b2bOrderItem_delete!.toJson();
    }
    return json;
  }

  DeleteB2bOrderItemData({
    this.b2bOrderItem_delete,
  });
}

@immutable
class DeleteB2bOrderItemVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteB2bOrderItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteB2bOrderItemVariables otherTyped = other as DeleteB2bOrderItemVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteB2bOrderItemVariables({
    required this.id,
  });
}

