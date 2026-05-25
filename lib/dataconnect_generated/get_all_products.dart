part of 'generated.dart';

class GetAllProductsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  GetAllProductsVariablesBuilder(this._dataConnect, );
  Deserializer<GetAllProductsData> dataDeserializer = (dynamic json)  => GetAllProductsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<GetAllProductsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetAllProductsData, void> ref() {
    
    return _dataConnect.query("GetAllProducts", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class GetAllProductsProducts {
  final String id;
  final String productName;
  final String modelNo;
  final double price;
  final String? imagePath;
  final double createdAt;
  final double updatedAt;
  GetAllProductsProducts.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productName = nativeFromJson<String>(json['productName']),
  modelNo = nativeFromJson<String>(json['modelNo']),
  price = nativeFromJson<double>(json['price']),
  imagePath = json['imagePath'] == null ? null : nativeFromJson<String>(json['imagePath']),
  createdAt = nativeFromJson<double>(json['createdAt']),
  updatedAt = nativeFromJson<double>(json['updatedAt']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllProductsProducts otherTyped = other as GetAllProductsProducts;
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
    if (imagePath != null) {
      json['imagePath'] = nativeToJson<String?>(imagePath);
    }
    json['createdAt'] = nativeToJson<double>(createdAt);
    json['updatedAt'] = nativeToJson<double>(updatedAt);
    return json;
  }

  GetAllProductsProducts({
    required this.id,
    required this.productName,
    required this.modelNo,
    required this.price,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });
}

@immutable
class GetAllProductsData {
  final List<GetAllProductsProducts> products;
  GetAllProductsData.fromJson(dynamic json):
  
  products = (json['products'] as List<dynamic>)
        .map((e) => GetAllProductsProducts.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetAllProductsData otherTyped = other as GetAllProductsData;
    return products == otherTyped.products;
    
  }
  @override
  int get hashCode => products.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['products'] = products.map((e) => e.toJson()).toList();
    return json;
  }

  GetAllProductsData({
    required this.products,
  });
}

