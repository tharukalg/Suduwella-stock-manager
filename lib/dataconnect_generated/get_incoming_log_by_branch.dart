part of 'generated.dart';

class GetIncomingLogByBranchVariablesBuilder {
  String branchCode;

  final FirebaseDataConnect _dataConnect;
  GetIncomingLogByBranchVariablesBuilder(this._dataConnect, {required  this.branchCode,});
  Deserializer<GetIncomingLogByBranchData> dataDeserializer = (dynamic json)  => GetIncomingLogByBranchData.fromJson(jsonDecode(json));
  Serializer<GetIncomingLogByBranchVariables> varsSerializer = (GetIncomingLogByBranchVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetIncomingLogByBranchData, GetIncomingLogByBranchVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetIncomingLogByBranchData, GetIncomingLogByBranchVariables> ref() {
    GetIncomingLogByBranchVariables vars= GetIncomingLogByBranchVariables(branchCode: branchCode,);
    return _dataConnect.query("GetIncomingLogByBranch", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetIncomingLogByBranchIncomingStockLogs {
  final String id;
  final String logType;
  final String serialNo;
  final String modelNo;
  final String productName;
  final String? referenceId;
  final String? notes;
  final double createdAt;
  GetIncomingLogByBranchIncomingStockLogs.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  logType = nativeFromJson<String>(json['logType']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  productName = nativeFromJson<String>(json['productName']),
  referenceId = json['referenceId'] == null ? null : nativeFromJson<String>(json['referenceId']),
  notes = json['notes'] == null ? null : nativeFromJson<String>(json['notes']),
  createdAt = nativeFromJson<double>(json['createdAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetIncomingLogByBranchIncomingStockLogs otherTyped = other as GetIncomingLogByBranchIncomingStockLogs;
    return id == otherTyped.id && 
    logType == otherTyped.logType && 
    serialNo == otherTyped.serialNo && 
    modelNo == otherTyped.modelNo && 
    productName == otherTyped.productName && 
    referenceId == otherTyped.referenceId && 
    notes == otherTyped.notes && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, logType.hashCode, serialNo.hashCode, modelNo.hashCode, productName.hashCode, referenceId.hashCode, notes.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['logType'] = nativeToJson<String>(logType);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['modelNo'] = nativeToJson<String>(modelNo);
    json['productName'] = nativeToJson<String>(productName);
    if (referenceId != null) {
      json['referenceId'] = nativeToJson<String?>(referenceId);
    }
    if (notes != null) {
      json['notes'] = nativeToJson<String?>(notes);
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    return json;
  }

  GetIncomingLogByBranchIncomingStockLogs({
    required this.id,
    required this.logType,
    required this.serialNo,
    required this.modelNo,
    required this.productName,
    this.referenceId,
    this.notes,
    required this.createdAt,
  });
}

@immutable
class GetIncomingLogByBranchData {
  final List<GetIncomingLogByBranchIncomingStockLogs> incomingStockLogs;
  GetIncomingLogByBranchData.fromJson(dynamic json):
  
  incomingStockLogs = (json['incomingStockLogs'] as List<dynamic>)
        .map((e) => GetIncomingLogByBranchIncomingStockLogs.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetIncomingLogByBranchData otherTyped = other as GetIncomingLogByBranchData;
    return incomingStockLogs == otherTyped.incomingStockLogs;
    
  }
  @override
  int get hashCode => incomingStockLogs.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['incomingStockLogs'] = incomingStockLogs.map((e) => e.toJson()).toList();
    return json;
  }

  GetIncomingLogByBranchData({
    required this.incomingStockLogs,
  });
}

@immutable
class GetIncomingLogByBranchVariables {
  final String branchCode;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetIncomingLogByBranchVariables.fromJson(Map<String, dynamic> json):
  
  branchCode = nativeFromJson<String>(json['branchCode']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetIncomingLogByBranchVariables otherTyped = other as GetIncomingLogByBranchVariables;
    return branchCode == otherTyped.branchCode;
    
  }
  @override
  int get hashCode => branchCode.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['branchCode'] = nativeToJson<String>(branchCode);
    return json;
  }

  GetIncomingLogByBranchVariables({
    required this.branchCode,
  });
}

