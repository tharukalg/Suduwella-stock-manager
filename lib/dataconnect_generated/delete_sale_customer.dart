part of 'generated.dart';

class DeleteSaleCustomerVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteSaleCustomerVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteSaleCustomerData> dataDeserializer = (dynamic json)  => DeleteSaleCustomerData.fromJson(jsonDecode(json));
  Serializer<DeleteSaleCustomerVariables> varsSerializer = (DeleteSaleCustomerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteSaleCustomerData, DeleteSaleCustomerVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteSaleCustomerData, DeleteSaleCustomerVariables> ref() {
    DeleteSaleCustomerVariables vars= DeleteSaleCustomerVariables(id: id,);
    return _dataConnect.mutation("DeleteSaleCustomer", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteSaleCustomerSaleCustomerDelete {
  final String id;
  DeleteSaleCustomerSaleCustomerDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleCustomerSaleCustomerDelete otherTyped = other as DeleteSaleCustomerSaleCustomerDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteSaleCustomerSaleCustomerDelete({
    required this.id,
  });
}

@immutable
class DeleteSaleCustomerData {
  final DeleteSaleCustomerSaleCustomerDelete? saleCustomer_delete;
  DeleteSaleCustomerData.fromJson(dynamic json):
  
  saleCustomer_delete = json['saleCustomer_delete'] == null ? null : DeleteSaleCustomerSaleCustomerDelete.fromJson(json['saleCustomer_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleCustomerData otherTyped = other as DeleteSaleCustomerData;
    return saleCustomer_delete == otherTyped.saleCustomer_delete;
    
  }
  @override
  int get hashCode => saleCustomer_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (saleCustomer_delete != null) {
      json['saleCustomer_delete'] = saleCustomer_delete!.toJson();
    }
    return json;
  }

  DeleteSaleCustomerData({
    this.saleCustomer_delete,
  });
}

@immutable
class DeleteSaleCustomerVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteSaleCustomerVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteSaleCustomerVariables otherTyped = other as DeleteSaleCustomerVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteSaleCustomerVariables({
    required this.id,
  });
}

