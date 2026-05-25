part of 'generated.dart';

class DeleteSaleVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteSaleVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteSaleData> dataDeserializer = (dynamic json)  => DeleteSaleData.fromJson(jsonDecode(json));
  Serializer<DeleteSaleVariables> varsSerializer = (DeleteSaleVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteSaleData, DeleteSaleVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteSaleData, DeleteSaleVariables> ref() {
    DeleteSaleVariables vars= DeleteSaleVariables(id: id,);
    return _dataConnect.mutation("DeleteSale", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteSaleSaleDelete {
  final String id;
  DeleteSaleSaleDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleSaleDelete otherTyped = other as DeleteSaleSaleDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteSaleSaleDelete({
    required this.id,
  });
}

@immutable
class DeleteSaleData {
  final DeleteSaleSaleDelete? sale_delete;
  DeleteSaleData.fromJson(dynamic json):
  
  sale_delete = json['sale_delete'] == null ? null : DeleteSaleSaleDelete.fromJson(json['sale_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleData otherTyped = other as DeleteSaleData;
    return sale_delete == otherTyped.sale_delete;
    
  }
  @override
  int get hashCode => sale_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (sale_delete != null) {
      json['sale_delete'] = sale_delete!.toJson();
    }
    return json;
  }

  DeleteSaleData({
    this.sale_delete,
  });
}

@immutable
class DeleteSaleVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteSaleVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleVariables otherTyped = other as DeleteSaleVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteSaleVariables({
    required this.id,
  });
}

