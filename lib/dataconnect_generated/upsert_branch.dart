part of 'generated.dart';

class UpsertBranchVariablesBuilder {
  String id;
  String name;
  bool isActive;

  final FirebaseDataConnect _dataConnect;
  UpsertBranchVariablesBuilder(this._dataConnect, {required  this.id,required  this.name,required  this.isActive,});
  Deserializer<UpsertBranchData> dataDeserializer = (dynamic json)  => UpsertBranchData.fromJson(jsonDecode(json));
  Serializer<UpsertBranchVariables> varsSerializer = (UpsertBranchVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertBranchData, UpsertBranchVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertBranchData, UpsertBranchVariables> ref() {
    UpsertBranchVariables vars= UpsertBranchVariables(id: id,name: name,isActive: isActive,);
    return _dataConnect.mutation("UpsertBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertBranchBranchUpsert {
  final String id;
  UpsertBranchBranchUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBranchBranchUpsert otherTyped = other as UpsertBranchBranchUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertBranchBranchUpsert({
    required this.id,
  });
}

@immutable
class UpsertBranchData {
  final UpsertBranchBranchUpsert branch_upsert;
  UpsertBranchData.fromJson(dynamic json):
  
  branch_upsert = UpsertBranchBranchUpsert.fromJson(json['branch_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBranchData otherTyped = other as UpsertBranchData;
    return branch_upsert == otherTyped.branch_upsert;
    
  }
  @override
  int get hashCode => branch_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branch_upsert'] = branch_upsert.toJson();
    return json;
  }

  UpsertBranchData({
    required this.branch_upsert,
  });
}

@immutable
class UpsertBranchVariables {
  final String id;
  final String name;
  final bool isActive;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertBranchVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']),
  isActive = nativeFromJson<bool>(json['isActive']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertBranchVariables otherTyped = other as UpsertBranchVariables;
    return id == otherTyped.id && 
    name == otherTyped.name && 
    isActive == otherTyped.isActive;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode, isActive.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    json['isActive'] = nativeToJson<bool>(isActive);
    return json;
  }

  UpsertBranchVariables({
    required this.id,
    required this.name,
    required this.isActive,
  });
}

