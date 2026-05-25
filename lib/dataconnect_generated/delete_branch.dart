part of 'generated.dart';

class DeleteBranchVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteBranchVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteBranchData> dataDeserializer = (dynamic json)  => DeleteBranchData.fromJson(jsonDecode(json));
  Serializer<DeleteBranchVariables> varsSerializer = (DeleteBranchVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteBranchData, DeleteBranchVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteBranchData, DeleteBranchVariables> ref() {
    DeleteBranchVariables vars= DeleteBranchVariables(id: id,);
    return _dataConnect.mutation("DeleteBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteBranchBranchDelete {
  final String id;
  DeleteBranchBranchDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteBranchBranchDelete otherTyped = other as DeleteBranchBranchDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteBranchBranchDelete({
    required this.id,
  });
}

@immutable
class DeleteBranchData {
  final DeleteBranchBranchDelete? branch_delete;
  DeleteBranchData.fromJson(dynamic json):
  
  branch_delete = json['branch_delete'] == null ? null : DeleteBranchBranchDelete.fromJson(json['branch_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteBranchData otherTyped = other as DeleteBranchData;
    return branch_delete == otherTyped.branch_delete;
    
  }
  @override
  int get hashCode => branch_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (branch_delete != null) {
      json['branch_delete'] = branch_delete!.toJson();
    }
    return json;
  }

  DeleteBranchData({
    this.branch_delete,
  });
}

@immutable
class DeleteBranchVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteBranchVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteBranchVariables otherTyped = other as DeleteBranchVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteBranchVariables({
    required this.id,
  });
}

