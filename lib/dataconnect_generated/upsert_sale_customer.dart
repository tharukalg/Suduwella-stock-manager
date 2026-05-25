part of 'generated.dart';

class UpsertSaleCustomerVariablesBuilder {
  String id;
  String saleId;
  String customerId;
  bool isPrimary;
  int sortOrder;

  final FirebaseDataConnect _dataConnect;
  UpsertSaleCustomerVariablesBuilder(this._dataConnect, {required  this.id,required  this.saleId,required  this.customerId,required  this.isPrimary,required  this.sortOrder,});
  Deserializer<UpsertSaleCustomerData> dataDeserializer = (dynamic json)  => UpsertSaleCustomerData.fromJson(jsonDecode(json));
  Serializer<UpsertSaleCustomerVariables> varsSerializer = (UpsertSaleCustomerVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertSaleCustomerData, UpsertSaleCustomerVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertSaleCustomerData, UpsertSaleCustomerVariables> ref() {
    UpsertSaleCustomerVariables vars= UpsertSaleCustomerVariables(id: id,saleId: saleId,customerId: customerId,isPrimary: isPrimary,sortOrder: sortOrder,);
    return _dataConnect.mutation("UpsertSaleCustomer", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertSaleCustomerSaleCustomerUpsert {
  final String id;
  UpsertSaleCustomerSaleCustomerUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleCustomerSaleCustomerUpsert otherTyped = other as UpsertSaleCustomerSaleCustomerUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertSaleCustomerSaleCustomerUpsert({
    required this.id,
  });
}

@immutable
class UpsertSaleCustomerData {
  final UpsertSaleCustomerSaleCustomerUpsert saleCustomer_upsert;
  UpsertSaleCustomerData.fromJson(dynamic json):
  
  saleCustomer_upsert = UpsertSaleCustomerSaleCustomerUpsert.fromJson(json['saleCustomer_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleCustomerData otherTyped = other as UpsertSaleCustomerData;
    return saleCustomer_upsert == otherTyped.saleCustomer_upsert;
    
  }
  @override
  int get hashCode => saleCustomer_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['saleCustomer_upsert'] = saleCustomer_upsert.toJson();
    return json;
  }

  UpsertSaleCustomerData({
    required this.saleCustomer_upsert,
  });
}

@immutable
class UpsertSaleCustomerVariables {
  final String id;
  final String saleId;
  final String customerId;
  final bool isPrimary;
  final int sortOrder;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertSaleCustomerVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  saleId = nativeFromJson<String>(json['saleId']),
  customerId = nativeFromJson<String>(json['customerId']),
  isPrimary = nativeFromJson<bool>(json['isPrimary']),
  sortOrder = nativeFromJson<int>(json['sortOrder']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertSaleCustomerVariables otherTyped = other as UpsertSaleCustomerVariables;
    return id == otherTyped.id && 
    saleId == otherTyped.saleId && 
    customerId == otherTyped.customerId && 
    isPrimary == otherTyped.isPrimary && 
    sortOrder == otherTyped.sortOrder;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, saleId.hashCode, customerId.hashCode, isPrimary.hashCode, sortOrder.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['saleId'] = nativeToJson<String>(saleId);
    json['customerId'] = nativeToJson<String>(customerId);
    json['isPrimary'] = nativeToJson<bool>(isPrimary);
    json['sortOrder'] = nativeToJson<int>(sortOrder);
    return json;
  }

  UpsertSaleCustomerVariables({
    required this.id,
    required this.saleId,
    required this.customerId,
    required this.isPrimary,
    required this.sortOrder,
  });
}

