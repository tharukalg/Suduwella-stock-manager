part of 'generated.dart';

class UpsertProductVariablesBuilder {
  String id;
  String productName;
  String modelNo;
  double price;
  Optional<String> _imagePath = Optional.optional(nativeFromJson, nativeToJson);
  double createdAt;
  double updatedAt;

  final FirebaseDataConnect _dataConnect;  UpsertProductVariablesBuilder imagePath(String? t) {
   _imagePath.value = t;
   return this;
  }

  UpsertProductVariablesBuilder(this._dataConnect, {required  this.id,required  this.productName,required  this.modelNo,required  this.price,required  this.createdAt,required  this.updatedAt,});
  Deserializer<UpsertProductData> dataDeserializer = (dynamic json)  => UpsertProductData.fromJson(jsonDecode(json));
  Serializer<UpsertProductVariables> varsSerializer = (UpsertProductVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<UpsertProductData, UpsertProductVariables>> execute() {
    return ref().execute();
  }

  MutationRef<UpsertProductData, UpsertProductVariables> ref() {
    UpsertProductVariables vars= UpsertProductVariables(id: id,productName: productName,modelNo: modelNo,price: price,imagePath: _imagePath,createdAt: createdAt,updatedAt: updatedAt,);
    return _dataConnect.mutation("UpsertProduct", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class UpsertProductProductUpsert {
  final String id;
  UpsertProductProductUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProductProductUpsert otherTyped = other as UpsertProductProductUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  UpsertProductProductUpsert({
    required this.id,
  });
}

@immutable
class UpsertProductData {
  final UpsertProductProductUpsert product_upsert;
  UpsertProductData.fromJson(dynamic json):
  
  product_upsert = UpsertProductProductUpsert.fromJson(json['product_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProductData otherTyped = other as UpsertProductData;
    return product_upsert == otherTyped.product_upsert;
    
  }
  @override
  int get hashCode => product_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['product_upsert'] = product_upsert.toJson();
    return json;
  }

  UpsertProductData({
    required this.product_upsert,
  });
}

@immutable
class UpsertProductVariables {
  final String id;
  final String productName;
  final String modelNo;
  final double price;
  late final Optional<String>imagePath;
  final double createdAt;
  final double updatedAt;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  UpsertProductVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  price = nativeFromJson<double>(json['price']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']) {
  
  
  
  
  
  
    imagePath = Optional.optional(nativeFromJson, nativeToJson);
    imagePath.value = json['imagePath'] == null ? null : nativeFromJson<String>(json['imagePath']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final UpsertProductVariables otherTyped = other as UpsertProductVariables;
    return id == otherTyped.id && 
    productName == otherTyped.productName && 
    modelNo == otherTyped.modelNo && 
    price == otherTyped.price && 
    imagePath == otherTyped.imagePath && 
    createdAt == otherTyped.createdAt && 
    updatedAt == otherTyped.updatedAt;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productName.hashCode, modelNo.hashCode, price.hashCode, imagePath.hashCode, createdAt.hashCode, updatedAt.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productName'] = nativeToJson<String>(productName);
    json['modelNo'] = nativeToJson<String>(modelNo);
    json['price'] = nativeToJson<double>(price);
    if(imagePath.state == OptionalState.set) {
      json['imagePath'] = imagePath.toJson();
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  UpsertProductVariables({
    required this.id,
    required this.productName,
    required this.modelNo,
    required this.price,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });
}

