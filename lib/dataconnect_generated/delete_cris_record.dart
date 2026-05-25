part of 'generated.dart';

class DeleteCrisRecordVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteCrisRecordVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteCrisRecordData> dataDeserializer = (dynamic json)  => DeleteCrisRecordData.fromJson(jsonDecode(json));
  Serializer<DeleteCrisRecordVariables> varsSerializer = (DeleteCrisRecordVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteCrisRecordData, DeleteCrisRecordVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteCrisRecordData, DeleteCrisRecordVariables> ref() {
    DeleteCrisRecordVariables vars= DeleteCrisRecordVariables(id: id,);
    return _dataConnect.mutation("DeleteCrisRecord", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteCrisRecordCrisRecordDelete {
  final String id;
  DeleteCrisRecordCrisRecordDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCrisRecordCrisRecordDelete otherTyped = other as DeleteCrisRecordCrisRecordDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCrisRecordCrisRecordDelete({
    required this.id,
  });
}

@immutable
class DeleteCrisRecordData {
  final DeleteCrisRecordCrisRecordDelete? crisRecord_delete;
  DeleteCrisRecordData.fromJson(dynamic json):
  
  crisRecord_delete = json['crisRecord_delete'] == null ? null : DeleteCrisRecordCrisRecordDelete.fromJson(json['crisRecord_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCrisRecordData otherTyped = other as DeleteCrisRecordData;
    return crisRecord_delete == otherTyped.crisRecord_delete;
    
  }
  @override
  int get hashCode => crisRecord_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (crisRecord_delete != null) {
      json['crisRecord_delete'] = crisRecord_delete!.toJson();
    }
    return json;
  }

  DeleteCrisRecordData({
    this.crisRecord_delete,
  });
}

@immutable
class DeleteCrisRecordVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteCrisRecordVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteCrisRecordVariables otherTyped = other as DeleteCrisRecordVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteCrisRecordVariables({
    required this.id,
  });
}

