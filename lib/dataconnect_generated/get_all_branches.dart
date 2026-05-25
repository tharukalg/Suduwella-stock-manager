part of 'generated.dart';

class GetAllBranchesVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllBranchesVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllBranchesData> dataDeserializer = (dynamic json)  => GetAllBranchesData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllBranchesData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAllBranchesData, void> ref() {
    
    return _dataConnect.query("GetAllBranches", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllBranchesBranches {
  final String id;
  final String name;
  final bool isActive;
  GetAllBranchesBranches.fromJson(dynamic json):
  
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

    final GetAllBranchesBranches otherTyped = other as GetAllBranchesBranches;
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

  GetAllBranchesBranches({
    required this.id,
    required this.name,
    required this.isActive,
  });
}

@immutable
class GetAllBranchesData {
  final List<GetAllBranchesBranches> branches;
  GetAllBranchesData.fromJson(dynamic json):
  
  branches = (json['branches'] as List<dynamic>)
        .map((e) => GetAllBranchesBranches.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllBranchesData otherTyped = other as GetAllBranchesData;
    return branches == otherTyped.branches;
    
  }
  @override
  int get hashCode => branches.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branches'] = branches.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllBranchesData({
    required this.branches,
  });
}

