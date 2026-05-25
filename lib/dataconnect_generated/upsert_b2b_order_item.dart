part of 'generated.dart';

class UpsertB2bOrderItemVariablesBuilder {
  String id;
  String orderId;
  Optional<String> _stockItemId = Optional.optional(nativeFromJson, nativeToJson);
  String serialNo;
  String modelNo;
  Optional<String> _notes = Optional.optional(nativeFromJson, nativeToJson);
  int sortOrder;

  final FirebaseDataConnect _dataConnect;  UpsertB2bOrderItemVariablesBuilder stockItemId(String? t) {
   _stockItemId.value = t;
   return this;
  }
  UpsertB2bOrderItemVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  UpsertB2bOrderItemVariablesBuilder(this._dataConnect, {required  this.id,required  this.orderId,required  this.serialNo,required  this.modelNo,required  this.sortOrder,});
  Deserializer<UpsertB2bOrderItemData> dataDeserializer = (dynamic json)  => UpsertB2bOrderItemData.fromJson(jsonDecode(json));
  Serializer<UpsertB2bOrderItemVariables> varsSerializer = (UpsertB2bOrderItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertB2bOrderItemData, UpsertB2bOrderItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertB2bOrderItemData, UpsertB2bOrderItemVariables> ref() {
    UpsertB2bOrderItemVariables vars= UpsertB2bOrderItemVariables(id: id,orderId: orderId,stockItemId: _stockItemId,serialNo: serialNo,modelNo: modelNo,notes: _notes,sortOrder: sortOrder,);
    return _dataConnect.mutation("UpsertB2bOrderItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertB2bOrderItemB2bOrderItemUpsert {
  final String id;
  UpsertB2bOrderItemB2bOrderItemUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertB2bOrderItemB2bOrderItemUpsert otherTyped = other as UpsertB2bOrderItemB2bOrderItemUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertB2bOrderItemB2bOrderItemUpsert({
    required this.id,
  });
}

@immutable
class UpsertB2bOrderItemData {
  final UpsertB2bOrderItemB2bOrderItemUpsert b2bOrderItem_upsert;
  UpsertB2bOrderItemData.fromJson(dynamic json):
  
  b2bOrderItem_upsert = UpsertB2bOrderItemB2bOrderItemUpsert.fromJson(json['b2bOrderItem_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertB2bOrderItemData otherTyped = other as UpsertB2bOrderItemData;
    return b2bOrderItem_upsert == otherTyped.b2bOrderItem_upsert;
    
  }
  @override
  int get hashCode => b2bOrderItem_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['b2bOrderItem_upsert'] = b2bOrderItem_upsert.toJson();
    return json;
  }

  UpsertB2bOrderItemData({
    required this.b2bOrderItem_upsert,
  });
}

@immutable
class UpsertB2bOrderItemVariables {
  final String id;
  final String orderId;
  late final Optional<String>stockItemId;
  final String serialNo;
  final String modelNo;
  late final Optional<String>notes;
  final int sortOrder;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertB2bOrderItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  orderId = nativeFromJson<String>(json['orderId']),
  serialNo = nativeFromJson<String>(json['serialNo']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  sortOrder = nativeFromJson<int>(json['sortOrder']) {
  
  
  
  
    stockItemId = Optional.optional(nativeFromJson, nativeToJson);
    stockItemId.value = json['stockItemId'] == null ? null : nativeFromJson<String>(json['stockItemId']);
  
  
  
  
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

    final UpsertB2bOrderItemVariables otherTyped = other as UpsertB2bOrderItemVariables;
    return id == otherTyped.id && 
    orderId == otherTyped.orderId && 
    stockItemId == otherTyped.stockItemId && 
    serialNo == otherTyped.serialNo && 
    modelNo == otherTyped.modelNo && 
    notes == otherTyped.notes && 
    sortOrder == otherTyped.sortOrder;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, orderId.hashCode, stockItemId.hashCode, serialNo.hashCode, modelNo.hashCode, notes.hashCode, sortOrder.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['orderId'] = nativeToJson<String>(orderId);
    if(stockItemId.state == OptionalState.set) {
      json['stockItemId'] = stockItemId.toJson();
    }
    json['serialNo'] = nativeToJson<String>(serialNo);
    json['modelNo'] = nativeToJson<String>(modelNo);
    if(notes.state == OptionalState.set) {
      json['notes'] = notes.toJson();
    }
    json['sortOrder'] = nativeToJson<int>(sortOrder);
    return json;
  }

  UpsertB2bOrderItemVariables({
    required this.id,
    required this.orderId,
    required this.stockItemId,
    required this.serialNo,
    required this.modelNo,
    required this.notes,
    required this.sortOrder,
  });
}

