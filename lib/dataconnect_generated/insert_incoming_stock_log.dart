part of 'generated.dart';

class InsertIncomingStockLogVariablesBuilder {
  String id;
  String logType;
  String serialNo;
  String modelNo;
  String productName;
  String branchCode;
  Optional<String> _referenceId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;

  final FirebaseDataConnect _dataConnect;  InsertIncomingStockLogVariablesBuilder referenceId(String? t) {
   _referenceId.value = t;
   return this;
  }
  InsertIncomingStockLogVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  InsertIncomingStockLogVariablesBuilder(this._dataConnect, {required  this.id,required  this.logType,required  this.serialNo,required  this.modelNo,required  this.productName,required  this.branchCode,required  this.createdAt,});
  Deserializer<InsertIncomingStockLogData> dataDeserializer = (dynamic json)  => InsertIncomingStockLogData.fromJson(jsonDecode(json));
  Serializer<InsertIncomingStockLogVariables> varsSerializer = (InsertIncomingStockLogVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<InsertIncomingStockLogData, InsertIncomingStockLogVariables>> execute() {
    return ref().execute();
  }

  MutationRef<InsertIncomingStockLogData, InsertIncomingStockLogVariables> ref() {
    InsertIncomingStockLogVariables vars= InsertIncomingStockLogVariables(id: id,logType: logType,serialNo: serialNo,modelNo: modelNo,productName: productName,branchCode: branchCode,referenceId: _referenceId,notes: _notes,createdAt: createdAt,);
    return _dataConnect.mutation("InsertIncomingStockLog", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class InsertIncomingStockLogIncomingStockLogInsert {
  final String id;
  InsertIncomingStockLogIncomingStockLogInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertIncomingStockLogIncomingStockLogInsert otherTyped = other as InsertIncomingStockLogIncomingStockLogInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  InsertIncomingStockLogIncomingStockLogInsert({
    required this.id,
  });
}

@immutable
class InsertIncomingStockLogData {
  final InsertIncomingStockLogIncomingStockLogInsert incomingStockLog_insert;
  InsertIncomingStockLogData.fromJson(dynamic json):
  
  incomingStockLog_insert = InsertIncomingStockLogIncomingStockLogInsert.fromJson(json['incomingStockLog_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertIncomingStockLogData otherTyped = other as InsertIncomingStockLogData;
    return incomingStockLog_insert == otherTyped.incomingStockLog_insert;
    
  }
  @override
  int get hashCode => incomingStockLog_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['incomingStockLog_insert'] = incomingStockLog_insert.toJson();
    return json;
  }

  InsertIncomingStockLogData({
    required this.incomingStockLog_insert,
  });
}

@immutable
class InsertIncomingStockLogVariables {
  final String id;
  final String logType;
  final String serialNo;
  final String modelNo;
  final String productName;
  final String branchCode;
  late final Optional<String>referenceId;
  late final Optional<String>notes;
  final double createdAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  InsertIncomingStockLogVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  logType = nativeFromJson<String>(json['logType']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  productName = nativeFromJson<String>(json['productName']),
  branchCode = nativeFromJson<String>(json['branchCode']),
  createdAt = nativeFromJson<double>(json['createdAt']) {
  
  
  
  
  
  
  
  
    referenceId = Optional.optional(nativeFromJson, nativeToJson);
    referenceId.value = json['referenceId'] == null ? null : nativeFromJson<String>(json['referenceId']);
  
  
    notes = Optional.optional(nativeFromJson, nativeToJson);
    notes.value = json['notes'] == null ? null : nativeFromJson<String>(json['notes']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final InsertIncomingStockLogVariables otherTyped = other as InsertIncomingStockLogVariables;
    return id == otherTyped.id && 
    logType == otherTyped.logType && 
    serialNo == otherTyped.serialNo && 
    modelNo == otherTyped.modelNo && 
    productName == otherTyped.productName && 
    branchCode == otherTyped.branchCode && 
    referenceId == otherTyped.referenceId && 
    notes == otherTyped.notes && 
    createdAt == otherTyped.createdAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, logType.hashCode, serialNo.hashCode, modelNo.hashCode, productName.hashCode, branchCode.hashCode, referenceId.hashCode, notes.hashCode, createdAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['logType'] = nativeToJson<String>(logType);
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['modelNo'] = nativeToJson<String>(modelNo);
    json['productName'] = nativeToJson<String>(productName);
    json['branchCode'] = nativeToJson<String>(branchCode);
    if(referenceId.state == OptionalState.set) {
      json['referenceId'] = referenceId.toJson();
    }
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    return json;
  }

  InsertIncomingStockLogVariables({
    required this.id,
    required this.logType,
    required this.serialNo,
    required this.modelNo,
    required this.productName,
    required this.branchCode,
    required this.referenceId,
    required this.notes,
    required this.createdAt,
  });
}

