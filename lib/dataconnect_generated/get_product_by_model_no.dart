part of 'generated.dart';

class GetProductByModelNoVariablesBuilder {
  String modelNo;

  final FirebaseDataConnect _dataConnect;
  GetProductByModelNoVariablesBuilder(this._dataConnect, {required  this.modelNo,});
  Deserializer<GetProductByModelNoData> dataDeserializer = (dynamic json)  => GetProductByModelNoData.fromJson(jsonDecode(json));
  Serializer<GetProductByModelNoVariables> varsSerializer = (GetProductByModelNoVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetProductByModelNoData, GetProductByModelNoVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetProductByModelNoData, GetProductByModelNoVariables> ref() {
    GetProductByModelNoVariables vars= GetProductByModelNoVariables(modelNo: modelNo,);
    return _dataConnect.query("GetProductByModelNo", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetProductByModelNoProducts {
  final String id;
  final String productName;
  final String modelNo;
  final double price;
  final String? imagePath;
  GetProductByModelNoProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  price = nativeFromJson<double>(json['price']),
  imagePath = json['imagePath'] == null ? null : nativeFromJson<String>(json['imagePath']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductByModelNoProducts otherTyped = other as GetProductByModelNoProducts;
    return id == otherTyped.id && 
    productName == otherTyped.productName && 
    modelNo == otherTyped.modelNo && 
    price == otherTyped.price && 
    imagePath == otherTyped.imagePath;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productName.hashCode, modelNo.hashCode, price.hashCode, imagePath.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productName'] = nativeToJson<String>(productName);
    json['modelNo'] = nativeToJson<String>(modelNo);
    json['price'] = nativeToJson<double>(price);
    if (imagePath != null) {
      json['imagePath'] = nativeToJson<String?>(imagePath);
    }
    return json;
  }

  GetProductByModelNoProducts({
    required this.id,
    required this.productName,
    required this.modelNo,
    required this.price,
    this.imagePath,
  });
}

@immutable
class GetProductByModelNoData {
  final List<GetProductByModelNoProducts> products;
  GetProductByModelNoData.fromJson(dynamic json):
  
  products = (json['products'] as List<dynamic>)
        .map((e) => GetProductByModelNoProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductByModelNoData otherTyped = other as GetProductByModelNoData;
    return products == otherTyped.products;
    
  }
  @override
  int get hashCode => products.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['products'] = products.map((e) => e.toJson()).toList();
    return json;
  }

  GetProductByModelNoData({
    required this.products,
  });
}

@immutable
class GetProductByModelNoVariables {
  final String modelNo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetProductByModelNoVariables.fromJson(Map<String, dynamic> json):
  
  modelNo = nativeFromJson<String>(json['modelNo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetProductByModelNoVariables otherTyped = other as GetProductByModelNoVariables;
    return modelNo == otherTyped.modelNo;
    
  }
  @override
  int get hashCode => modelNo.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['modelNo'] = nativeToJson<String>(modelNo);
    return json;
  }

  GetProductByModelNoVariables({
    required this.modelNo,
  });
}

