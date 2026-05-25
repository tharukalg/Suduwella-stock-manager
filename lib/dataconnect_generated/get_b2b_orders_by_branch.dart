part of 'generated.dart';

class GetB2bOrdersByBranchVariablesBuilder {
  String branchCode;

  final FirebaseDataConnect _dataConnect;
  GetB2bOrdersByBranchVariablesBuilder(this._dataConnect, {required  this.branchCode,});
  Deserializer<GetB2bOrdersByBranchData> dataDeserializer = (dynamic json)  => GetB2bOrdersByBranchData.fromJson(jsonDecode(json));
  Serializer<GetB2bOrdersByBranchVariables> varsSerializer = (GetB2bOrdersByBranchVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetB2bOrdersByBranchData, GetB2bOrdersByBranchVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetB2bOrdersByBranchData, GetB2bOrdersByBranchVariables> ref() {
    GetB2bOrdersByBranchVariables vars= GetB2bOrdersByBranchVariables(branchCode: branchCode,);
    return _dataConnect.query("GetB2bOrdersByBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetB2bOrdersByBranchB2bOrders {
  final String id;
  final String orderRef;
  final String status;
  final String? notes;
  final double createdAt;
  final GetB2bOrdersByBranchB2bOrdersSourceBranch sourceBranch;
  final GetB2bOrdersByBranchB2bOrdersDestinationBranch destinationBranch;
  GetB2bOrdersByBranchB2bOrders.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  orderRef = nativeFromJson<String>(json['orderRef']),
  status = nativeFromJson<String>(json['status']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  sourceBranch = GetB2bOrdersByBranchB2bOrdersSourceBranch.fromJson(json['sourceBranch']),
  destinationBranch = GetB2bOrdersByBranchB2bOrdersDestinationBranch.fromJson(json['destinationBranch']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetB2bOrdersByBranchB2bOrders otherTyped = other as GetB2bOrdersByBranchB2bOrders;
    return id == otherTyped.id && 
    orderRef == otherTyped.orderRef && 
    status == otherTyped.status && 
    notes == otherTyped.notes && 
    createdAt == otherTyped.createdAt && 
    sourceBranch == otherTyped.sourceBranch && 
    destinationBranch == otherTyped.destinationBranch;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderRef.hashCode, status.hashCode, notes.hashCode, createdAt.hashCode, sourceBranch.hashCode, destinationBranch.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderRef'] = nativeToJson<String>(orderRef);
    json['status'] = nativeToJson<String>(status);
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['sourceBranch'] = sourceBranch.toJson();
    json['destinationBranch'] = destinationBranch.toJson();
    return json;
  }

  GetB2bOrdersByBranchB2bOrders({
    required this.id,
    required this.orderRef,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.sourceBranch,
    required this.destinationBranch,
  });
}

@immutable
class GetB2bOrdersByBranchB2bOrdersSourceBranch {
  final String id;
  final String name;
  GetB2bOrdersByBranchB2bOrdersSourceBranch.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetB2bOrdersByBranchB2bOrdersSourceBranch otherTyped = other as GetB2bOrdersByBranchB2bOrdersSourceBranch;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetB2bOrdersByBranchB2bOrdersSourceBranch({
    required this.id,
    required this.name,
  });
}

@immutable
class GetB2bOrdersByBranchB2bOrdersDestinationBranch {
  final String id;
  final String name;
  GetB2bOrdersByBranchB2bOrdersDestinationBranch.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  name = nativeFromJson<String>(json['name']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetB2bOrdersByBranchB2bOrdersDestinationBranch otherTyped = other as GetB2bOrdersByBranchB2bOrdersDestinationBranch;
    return id == otherTyped.id && 
    name == otherTyped.name;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, name.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['name'] = nativeToJson<String>(name);
    return json;
  }

  GetB2bOrdersByBranchB2bOrdersDestinationBranch({
    required this.id,
    required this.name,
  });
}

@immutable
class GetB2bOrdersByBranchData {
  final List<GetB2bOrdersByBranchB2bOrders> b2bOrders;
  GetB2bOrdersByBranchData.fromJson(dynamic json):
  
  b2bOrders = (json['b2bOrders'] as List<dynamic>)
        .map((e) => GetB2bOrdersByBranchB2bOrders.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetB2bOrdersByBranchData otherTyped = other as GetB2bOrdersByBranchData;
    return b2bOrders == otherTyped.b2bOrders;
    
  }
  @override
  int get hashCode => b2bOrders.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['b2bOrders'] = b2bOrders.map((e) => e.toJson()).toList();
    return json;
  }

  GetB2bOrdersByBranchData({
    required this.b2bOrders,
  });
}

@immutable
class GetB2bOrdersByBranchVariables {
  final String branchCode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetB2bOrdersByBranchVariables.fromJson(Map<String, dynamic> json):
  
  branchCode = nativeFromJson<String>(json['branchCode']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetB2bOrdersByBranchVariables otherTyped = other as GetB2bOrdersByBranchVariables;
    return branchCode == otherTyped.branchCode;
    
  }
  @override
  int get hashCode => branchCode.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branchCode'] = nativeToJson<String>(branchCode);
    return json;
  }

  GetB2bOrdersByBranchVariables({
    required this.branchCode,
  });
}

