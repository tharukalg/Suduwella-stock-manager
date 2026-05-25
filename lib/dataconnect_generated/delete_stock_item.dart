part of 'generated.dart';

class DeleteStockItemVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteStockItemVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteStockItemData> dataDeserializer = (dynamic json)  => DeleteStockItemData.fromJson(jsonDecode(json));
  Serializer<DeleteStockItemVariables> varsSerializer = (DeleteStockItemVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteStockItemData, DeleteStockItemVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteStockItemData, DeleteStockItemVariables> ref() {
    DeleteStockItemVariables vars= DeleteStockItemVariables(id: id,);
    return _dataConnect.mutation("DeleteStockItem", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteStockItemStockItemDelete {
  final String id;
  DeleteStockItemStockItemDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStockItemStockItemDelete otherTyped = other as DeleteStockItemStockItemDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStockItemStockItemDelete({
    required this.id,
  });
}

@immutable
class DeleteStockItemData {
  final DeleteStockItemStockItemDelete? stockItem_delete;
  DeleteStockItemData.fromJson(dynamic json):
  
  stockItem_delete = json['stockItem_delete'] == null ? null : DeleteStockItemStockItemDelete.fromJson(json['stockItem_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStockItemData otherTyped = other as DeleteStockItemData;
    return stockItem_delete == otherTyped.stockItem_delete;
    
  }
  @override
  int get hashCode => stockItem_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (stockItem_delete != null) {
      json['stockItem_delete'] = stockItem_delete!.toJson();
    }
    return json;
  }

  DeleteStockItemData({
    this.stockItem_delete,
  });
}

@immutable
class DeleteStockItemVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteStockItemVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteStockItemVariables otherTyped = other as DeleteStockItemVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteStockItemVariables({
    required this.id,
  });
}

