part of 'generated.dart';

class UpsertB2bOrderVariablesBuilder {
  String id;
  String orderRef;
  String sourceBranchId;
  String destinationBranchId;
  String status;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertB2bOrderVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  UpsertB2bOrderVariablesBuilder(this._dataConnect, {required  this.id,required  this.orderRef,required  this.sourceBranchId,required  this.destinationBranchId,required  this.status,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertB2bOrderData> dataDeserializer = (dynamic json)  => UpsertB2bOrderData.fromJson(jsonDecode(json));
  Serializer<UpsertB2bOrderVariables> varsSerializer = (UpsertB2bOrderVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertB2bOrderData, UpsertB2bOrderVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertB2bOrderData, UpsertB2bOrderVariables> ref() {
    UpsertB2bOrderVariables vars= UpsertB2bOrderVariables(id: id,orderRef: orderRef,sourceBranchId: sourceBranchId,destinationBranchId: destinationBranchId,status: status,notes: _notes,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertB2bOrder", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertB2bOrderB2bOrderUpsert {
  final String id;
  UpsertB2bOrderB2bOrderUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertB2bOrderB2bOrderUpsert otherTyped = other as UpsertB2bOrderB2bOrderUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertB2bOrderB2bOrderUpsert({
    required this.id,
  });
}

@immutable
class UpsertB2bOrderData {
  final UpsertB2bOrderB2bOrderUpsert b2bOrder_upsert;
  UpsertB2bOrderData.fromJson(dynamic json):
  
  b2bOrder_upsert = UpsertB2bOrderB2bOrderUpsert.fromJson(json['b2bOrder_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertB2bOrderData otherTyped = other as UpsertB2bOrderData;
    return b2bOrder_upsert == otherTyped.b2bOrder_upsert;
    
  }
  @override
  int get hashCode => b2bOrder_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['b2bOrder_upsert'] = b2bOrder_upsert.toJson();
    return json;
  }

  UpsertB2bOrderData({
    required this.b2bOrder_upsert,
  });
}

@immutable
class UpsertB2bOrderVariables {
  final String id;
  final String orderRef;
  final String sourceBranchId;
  final String destinationBranchId;
  final String status;
  late final Optional<String>notes;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertB2bOrderVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  orderRef = nativeFromJson<String>(json['orderRef']),
  sourceBranchId = nativeFromJson<String>(json['sourceBranchId']),
  destinationBranchId = nativeFromJson<String>(json['destinationBranchId']),
  status = nativeFromJson<String>(json['status']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
  
  
  
  
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

    final UpsertB2bOrderVariables otherTyped = other as UpsertB2bOrderVariables;
    return id == otherTyped.id && 
    orderRef == otherTyped.orderRef && 
    sourceBranchId == otherTyped.sourceBranchId && 
    destinationBranchId == otherTyped.destinationBranchId && 
    status == otherTyped.status && 
    notes == otherTyped.notes && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderRef.hashCode, sourceBranchId.hashCode, destinationBranchId.hashCode, status.hashCode, notes.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderRef'] = nativeToJson<String>(orderRef);
    json['sourceBranchId'] = nativeToJson<String>(sourceBranchId);
    json['destinationBranchId'] = nativeToJson<String>(destinationBranchId);
    json['status'] = nativeToJson<String>(status);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertB2bOrderVariables({
    required this.id,
    required this.orderRef,
    required this.sourceBranchId,
    required this.destinationBranchId,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
}

