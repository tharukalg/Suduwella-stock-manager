part of 'generated.dart';

class DeleteEasyPaymentBillVariablesBuilder {
  String id;

  final FirebaseDataConnect _dataConnect;
  DeleteEasyPaymentBillVariablesBuilder(this._dataConnect, {required  this.id,});
  Deserializer<DeleteEasyPaymentBillData> dataDeserializer = (dynamic json)  => DeleteEasyPaymentBillData.fromJson(jsonDecode(json));
  Serializer<DeleteEasyPaymentBillVariables> varsSerializer = (DeleteEasyPaymentBillVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DeleteEasyPaymentBillData, DeleteEasyPaymentBillVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DeleteEasyPaymentBillData, DeleteEasyPaymentBillVariables> ref() {
    DeleteEasyPaymentBillVariables vars= DeleteEasyPaymentBillVariables(id: id,);
    return _dataConnect.mutation("DeleteEasyPaymentBill", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DeleteEasyPaymentBillEasyPaymentBillDelete {
  final String id;
  DeleteEasyPaymentBillEasyPaymentBillDelete.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEasyPaymentBillEasyPaymentBillDelete otherTyped = other as DeleteEasyPaymentBillEasyPaymentBillDelete;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteEasyPaymentBillEasyPaymentBillDelete({
    required this.id,
  });
}

@immutable
class DeleteEasyPaymentBillData {
  final DeleteEasyPaymentBillEasyPaymentBillDelete? easyPaymentBill_delete;
  DeleteEasyPaymentBillData.fromJson(dynamic json):
  
  easyPaymentBill_delete = json['easyPaymentBill_delete'] == null ? null : DeleteEasyPaymentBillEasyPaymentBillDelete.fromJson(json['easyPaymentBill_delete']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEasyPaymentBillData otherTyped = other as DeleteEasyPaymentBillData;
    return easyPaymentBill_delete == otherTyped.easyPaymentBill_delete;
    
  }
  @override
  int get hashCode => easyPaymentBill_delete.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (easyPaymentBill_delete != null) {
      json['easyPaymentBill_delete'] = easyPaymentBill_delete!.toJson();
    }
    return json;
  }

  DeleteEasyPaymentBillData({
    this.easyPaymentBill_delete,
  });
}

@immutable
class DeleteEasyPaymentBillVariables {
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DeleteEasyPaymentBillVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DeleteEasyPaymentBillVariables otherTyped = other as DeleteEasyPaymentBillVariables;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DeleteEasyPaymentBillVariables({
    required this.id,
  });
}

