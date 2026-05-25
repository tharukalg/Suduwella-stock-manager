# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ExampleConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### GetAllBranches
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getAllBranches().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllBranchesData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAllBranches();
GetAllBranchesData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getAllBranches().ref();
ref.execute();

ref.subscribe(...);
```


### GetAllProducts
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getAllProducts().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetAllProductsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getAllProducts();
GetAllProductsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getAllProducts().ref();
ref.execute();

ref.subscribe(...);
```


### GetProductByModelNo
#### Required Arguments
```dart
String modelNo = ...;
ExampleConnector.instance.getProductByModelNo(
  modelNo: modelNo,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetProductByModelNoData, GetProductByModelNoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getProductByModelNo(
  modelNo: modelNo,
);
GetProductByModelNoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String modelNo = ...;

final ref = ExampleConnector.instance.getProductByModelNo(
  modelNo: modelNo,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetStockByBranch
#### Required Arguments
```dart
String branchCode = ...;
ExampleConnector.instance.getStockByBranch(
  branchCode: branchCode,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetStockByBranchData, GetStockByBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getStockByBranch(
  branchCode: branchCode,
);
GetStockByBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String branchCode = ...;

final ref = ExampleConnector.instance.getStockByBranch(
  branchCode: branchCode,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetStockItemBySerial
#### Required Arguments
```dart
String serialNo = ...;
ExampleConnector.instance.getStockItemBySerial(
  serialNo: serialNo,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetStockItemBySerialData, GetStockItemBySerialVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getStockItemBySerial(
  serialNo: serialNo,
);
GetStockItemBySerialData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String serialNo = ...;

final ref = ExampleConnector.instance.getStockItemBySerial(
  serialNo: serialNo,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetCustomerByNic
#### Required Arguments
```dart
String nic = ...;
ExampleConnector.instance.getCustomerByNic(
  nic: nic,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCustomerByNicData, GetCustomerByNicVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getCustomerByNic(
  nic: nic,
);
GetCustomerByNicData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String nic = ...;

final ref = ExampleConnector.instance.getCustomerByNic(
  nic: nic,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetCustomerByPhone
#### Required Arguments
```dart
String phone = ...;
ExampleConnector.instance.getCustomerByPhone(
  phone: phone,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCustomerByPhoneData, GetCustomerByPhoneVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getCustomerByPhone(
  phone: phone,
);
GetCustomerByPhoneData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String phone = ...;

final ref = ExampleConnector.instance.getCustomerByPhone(
  phone: phone,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetSaleByBlNumber
#### Required Arguments
```dart
String blNumber = ...;
ExampleConnector.instance.getSaleByBlNumber(
  blNumber: blNumber,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetSaleByBlNumberData, GetSaleByBlNumberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getSaleByBlNumber(
  blNumber: blNumber,
);
GetSaleByBlNumberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String blNumber = ...;

final ref = ExampleConnector.instance.getSaleByBlNumber(
  blNumber: blNumber,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveSalesByBranch
#### Required Arguments
```dart
String branchCode = ...;
ExampleConnector.instance.getActiveSalesByBranch(
  branchCode: branchCode,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveSalesByBranchData, GetActiveSalesByBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getActiveSalesByBranch(
  branchCode: branchCode,
);
GetActiveSalesByBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String branchCode = ...;

final ref = ExampleConnector.instance.getActiveSalesByBranch(
  branchCode: branchCode,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetBillByNumber
#### Required Arguments
```dart
String billNumber = ...;
ExampleConnector.instance.getBillByNumber(
  billNumber: billNumber,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetBillByNumberData, GetBillByNumberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getBillByNumber(
  billNumber: billNumber,
);
GetBillByNumberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String billNumber = ...;

final ref = ExampleConnector.instance.getBillByNumber(
  billNumber: billNumber,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetActiveBills
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getActiveBills().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetActiveBillsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getActiveBills();
GetActiveBillsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getActiveBills().ref();
ref.execute();

ref.subscribe(...);
```


### GetCrisRecordByDNumber
#### Required Arguments
```dart
String dNumber = ...;
ExampleConnector.instance.getCrisRecordByDNumber(
  dNumber: dNumber,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetCrisRecordByDNumberData, GetCrisRecordByDNumberVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getCrisRecordByDNumber(
  dNumber: dNumber,
);
GetCrisRecordByDNumberData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String dNumber = ...;

final ref = ExampleConnector.instance.getCrisRecordByDNumber(
  dNumber: dNumber,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetOverdueCrisRecords
#### Required Arguments
```dart
// No required arguments
ExampleConnector.instance.getOverdueCrisRecords().execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetOverdueCrisRecordsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getOverdueCrisRecords();
GetOverdueCrisRecordsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ExampleConnector.instance.getOverdueCrisRecords().ref();
ref.execute();

ref.subscribe(...);
```


### GetB2bOrdersByBranch
#### Required Arguments
```dart
String branchCode = ...;
ExampleConnector.instance.getB2bOrdersByBranch(
  branchCode: branchCode,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetB2bOrdersByBranchData, GetB2bOrdersByBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getB2bOrdersByBranch(
  branchCode: branchCode,
);
GetB2bOrdersByBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String branchCode = ...;

final ref = ExampleConnector.instance.getB2bOrdersByBranch(
  branchCode: branchCode,
).ref();
ref.execute();

ref.subscribe(...);
```


### GetIncomingLogByBranch
#### Required Arguments
```dart
String branchCode = ...;
ExampleConnector.instance.getIncomingLogByBranch(
  branchCode: branchCode,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetIncomingLogByBranchData, GetIncomingLogByBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ExampleConnector.instance.getIncomingLogByBranch(
  branchCode: branchCode,
);
GetIncomingLogByBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String branchCode = ...;

final ref = ExampleConnector.instance.getIncomingLogByBranch(
  branchCode: branchCode,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### UpsertBranch
#### Required Arguments
```dart
String id = ...;
String name = ...;
bool isActive = ...;
ExampleConnector.instance.upsertBranch(
  id: id,
  name: name,
  isActive: isActive,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertBranchData, UpsertBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertBranch(
  id: id,
  name: name,
  isActive: isActive,
);
UpsertBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String name = ...;
bool isActive = ...;

final ref = ExampleConnector.instance.upsertBranch(
  id: id,
  name: name,
  isActive: isActive,
).ref();
ref.execute();
```


### DeleteBranch
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteBranch(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteBranchData, DeleteBranchVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteBranch(
  id: id,
);
DeleteBranchData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteBranch(
  id: id,
).ref();
ref.execute();
```


### UpsertProduct
#### Required Arguments
```dart
String id = ...;
String productName = ...;
String modelNo = ...;
double price = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertProduct(
  id: id,
  productName: productName,
  modelNo: modelNo,
  price: price,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertProduct, we created `UpsertProductBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertProductVariablesBuilder {
  ...
   UpsertProductVariablesBuilder imagePath(String? t) {
   _imagePath.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertProduct(
  id: id,
  productName: productName,
  modelNo: modelNo,
  price: price,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.imagePath(imagePath)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertProductData, UpsertProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertProduct(
  id: id,
  productName: productName,
  modelNo: modelNo,
  price: price,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String productName = ...;
String modelNo = ...;
double price = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertProduct(
  id: id,
  productName: productName,
  modelNo: modelNo,
  price: price,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteProduct
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteProduct(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteProductData, DeleteProductVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteProduct(
  id: id,
);
DeleteProductData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteProduct(
  id: id,
).ref();
ref.execute();
```


### UpsertStockItem
#### Required Arguments
```dart
String id = ...;
String productId = ...;
String branchCode = ...;
String serialNo = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertStockItem(
  id: id,
  productId: productId,
  branchCode: branchCode,
  serialNo: serialNo,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertStockItemData, UpsertStockItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertStockItem(
  id: id,
  productId: productId,
  branchCode: branchCode,
  serialNo: serialNo,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertStockItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String productId = ...;
String branchCode = ...;
String serialNo = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertStockItem(
  id: id,
  productId: productId,
  branchCode: branchCode,
  serialNo: serialNo,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteStockItem
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteStockItem(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteStockItemData, DeleteStockItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteStockItem(
  id: id,
);
DeleteStockItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteStockItem(
  id: id,
).ref();
ref.execute();
```


### UpsertCustomer
#### Required Arguments
```dart
String id = ...;
String nic = ...;
String name = ...;
String phone = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertCustomer(
  id: id,
  nic: nic,
  name: name,
  phone: phone,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCustomer, we created `UpsertCustomerBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCustomerVariablesBuilder {
  ...
   UpsertCustomerVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertCustomer(
  id: id,
  nic: nic,
  name: name,
  phone: phone,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.description(description)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCustomerData, UpsertCustomerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertCustomer(
  id: id,
  nic: nic,
  name: name,
  phone: phone,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertCustomerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String nic = ...;
String name = ...;
String phone = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertCustomer(
  id: id,
  nic: nic,
  name: name,
  phone: phone,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteCustomer
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteCustomer(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCustomerData, DeleteCustomerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteCustomer(
  id: id,
);
DeleteCustomerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteCustomer(
  id: id,
).ref();
ref.execute();
```


### UpsertCustomerPhoto
#### Required Arguments
```dart
String id = ...;
String customerId = ...;
String photoType = ...;
double createdAt = ...;
ExampleConnector.instance.upsertCustomerPhoto(
  id: id,
  customerId: customerId,
  photoType: photoType,
  createdAt: createdAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCustomerPhoto, we created `UpsertCustomerPhotoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCustomerPhotoVariablesBuilder {
  ...
   UpsertCustomerPhotoVariablesBuilder remoteUrl(String? t) {
   _remoteUrl.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertCustomerPhoto(
  id: id,
  customerId: customerId,
  photoType: photoType,
  createdAt: createdAt,
)
.remoteUrl(remoteUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCustomerPhotoData, UpsertCustomerPhotoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertCustomerPhoto(
  id: id,
  customerId: customerId,
  photoType: photoType,
  createdAt: createdAt,
);
UpsertCustomerPhotoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String customerId = ...;
String photoType = ...;
double createdAt = ...;

final ref = ExampleConnector.instance.upsertCustomerPhoto(
  id: id,
  customerId: customerId,
  photoType: photoType,
  createdAt: createdAt,
).ref();
ref.execute();
```


### DeleteCustomerPhoto
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteCustomerPhoto(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCustomerPhotoData, DeleteCustomerPhotoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteCustomerPhoto(
  id: id,
);
DeleteCustomerPhotoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteCustomerPhoto(
  id: id,
).ref();
ref.execute();
```


### UpsertSale
#### Required Arguments
```dart
String id = ...;
String blNumber = ...;
String branchCode = ...;
String stockItemId = ...;
String paymentPlan = ...;
double downPayment = ...;
double totalAmount = ...;
double financedAmount = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertSale(
  id: id,
  blNumber: blNumber,
  branchCode: branchCode,
  stockItemId: stockItemId,
  paymentPlan: paymentPlan,
  downPayment: downPayment,
  totalAmount: totalAmount,
  financedAmount: financedAmount,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertSale, we created `UpsertSaleBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertSaleVariablesBuilder {
  ...
   UpsertSaleVariablesBuilder durationMonths(int? t) {
   _durationMonths.value = t;
   return this;
  }
  UpsertSaleVariablesBuilder monthlyInstallment(double? t) {
   _monthlyInstallment.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertSale(
  id: id,
  blNumber: blNumber,
  branchCode: branchCode,
  stockItemId: stockItemId,
  paymentPlan: paymentPlan,
  downPayment: downPayment,
  totalAmount: totalAmount,
  financedAmount: financedAmount,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.durationMonths(durationMonths)
.monthlyInstallment(monthlyInstallment)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertSaleData, UpsertSaleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertSale(
  id: id,
  blNumber: blNumber,
  branchCode: branchCode,
  stockItemId: stockItemId,
  paymentPlan: paymentPlan,
  downPayment: downPayment,
  totalAmount: totalAmount,
  financedAmount: financedAmount,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertSaleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String blNumber = ...;
String branchCode = ...;
String stockItemId = ...;
String paymentPlan = ...;
double downPayment = ...;
double totalAmount = ...;
double financedAmount = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertSale(
  id: id,
  blNumber: blNumber,
  branchCode: branchCode,
  stockItemId: stockItemId,
  paymentPlan: paymentPlan,
  downPayment: downPayment,
  totalAmount: totalAmount,
  financedAmount: financedAmount,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteSale
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteSale(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteSaleData, DeleteSaleVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteSale(
  id: id,
);
DeleteSaleData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteSale(
  id: id,
).ref();
ref.execute();
```


### UpsertSaleCustomer
#### Required Arguments
```dart
String id = ...;
String saleId = ...;
String customerId = ...;
bool isPrimary = ...;
int sortOrder = ...;
ExampleConnector.instance.upsertSaleCustomer(
  id: id,
  saleId: saleId,
  customerId: customerId,
  isPrimary: isPrimary,
  sortOrder: sortOrder,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<UpsertSaleCustomerData, UpsertSaleCustomerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertSaleCustomer(
  id: id,
  saleId: saleId,
  customerId: customerId,
  isPrimary: isPrimary,
  sortOrder: sortOrder,
);
UpsertSaleCustomerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String saleId = ...;
String customerId = ...;
bool isPrimary = ...;
int sortOrder = ...;

final ref = ExampleConnector.instance.upsertSaleCustomer(
  id: id,
  saleId: saleId,
  customerId: customerId,
  isPrimary: isPrimary,
  sortOrder: sortOrder,
).ref();
ref.execute();
```


### DeleteSaleCustomer
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteSaleCustomer(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteSaleCustomerData, DeleteSaleCustomerVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteSaleCustomer(
  id: id,
);
DeleteSaleCustomerData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteSaleCustomer(
  id: id,
).ref();
ref.execute();
```


### UpsertEasyPaymentBill
#### Required Arguments
```dart
String id = ...;
String billNumber = ...;
double currentBalance = ...;
double totalPaid = ...;
int remainingMonths = ...;
double monthlyInstallment = ...;
bool isActive = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertEasyPaymentBill(
  id: id,
  billNumber: billNumber,
  currentBalance: currentBalance,
  totalPaid: totalPaid,
  remainingMonths: remainingMonths,
  monthlyInstallment: monthlyInstallment,
  isActive: isActive,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertEasyPaymentBill, we created `UpsertEasyPaymentBillBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertEasyPaymentBillVariablesBuilder {
  ...
   UpsertEasyPaymentBillVariablesBuilder saleId(String? t) {
   _saleId.value = t;
   return this;
  }
  UpsertEasyPaymentBillVariablesBuilder lastPaymentAmount(double? t) {
   _lastPaymentAmount.value = t;
   return this;
  }
  UpsertEasyPaymentBillVariablesBuilder lastPaymentDate(double? t) {
   _lastPaymentDate.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertEasyPaymentBill(
  id: id,
  billNumber: billNumber,
  currentBalance: currentBalance,
  totalPaid: totalPaid,
  remainingMonths: remainingMonths,
  monthlyInstallment: monthlyInstallment,
  isActive: isActive,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.saleId(saleId)
.lastPaymentAmount(lastPaymentAmount)
.lastPaymentDate(lastPaymentDate)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertEasyPaymentBillData, UpsertEasyPaymentBillVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertEasyPaymentBill(
  id: id,
  billNumber: billNumber,
  currentBalance: currentBalance,
  totalPaid: totalPaid,
  remainingMonths: remainingMonths,
  monthlyInstallment: monthlyInstallment,
  isActive: isActive,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertEasyPaymentBillData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String billNumber = ...;
double currentBalance = ...;
double totalPaid = ...;
int remainingMonths = ...;
double monthlyInstallment = ...;
bool isActive = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertEasyPaymentBill(
  id: id,
  billNumber: billNumber,
  currentBalance: currentBalance,
  totalPaid: totalPaid,
  remainingMonths: remainingMonths,
  monthlyInstallment: monthlyInstallment,
  isActive: isActive,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteEasyPaymentBill
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteEasyPaymentBill(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteEasyPaymentBillData, DeleteEasyPaymentBillVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteEasyPaymentBill(
  id: id,
);
DeleteEasyPaymentBillData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteEasyPaymentBill(
  id: id,
).ref();
ref.execute();
```


### InsertEasyPaymentTransaction
#### Required Arguments
```dart
String id = ...;
String billId = ...;
String transactionType = ...;
String branchCode = ...;
double createdAt = ...;
ExampleConnector.instance.insertEasyPaymentTransaction(
  id: id,
  billId: billId,
  transactionType: transactionType,
  branchCode: branchCode,
  createdAt: createdAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For InsertEasyPaymentTransaction, we created `InsertEasyPaymentTransactionBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class InsertEasyPaymentTransactionVariablesBuilder {
  ...
   InsertEasyPaymentTransactionVariablesBuilder amount(double? t) {
   _amount.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder remainingMonths(int? t) {
   _remainingMonths.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder newMonthlyInstallment(double? t) {
   _newMonthlyInstallment.value = t;
   return this;
  }
  InsertEasyPaymentTransactionVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.insertEasyPaymentTransaction(
  id: id,
  billId: billId,
  transactionType: transactionType,
  branchCode: branchCode,
  createdAt: createdAt,
)
.amount(amount)
.remainingMonths(remainingMonths)
.newMonthlyInstallment(newMonthlyInstallment)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<InsertEasyPaymentTransactionData, InsertEasyPaymentTransactionVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.insertEasyPaymentTransaction(
  id: id,
  billId: billId,
  transactionType: transactionType,
  branchCode: branchCode,
  createdAt: createdAt,
);
InsertEasyPaymentTransactionData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String billId = ...;
String transactionType = ...;
String branchCode = ...;
double createdAt = ...;

final ref = ExampleConnector.instance.insertEasyPaymentTransaction(
  id: id,
  billId: billId,
  transactionType: transactionType,
  branchCode: branchCode,
  createdAt: createdAt,
).ref();
ref.execute();
```


### UpsertB2bOrder
#### Required Arguments
```dart
String id = ...;
String orderRef = ...;
String sourceBranchId = ...;
String destinationBranchId = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertB2bOrder(
  id: id,
  orderRef: orderRef,
  sourceBranchId: sourceBranchId,
  destinationBranchId: destinationBranchId,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertB2bOrder, we created `UpsertB2bOrderBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertB2bOrderVariablesBuilder {
  ...
   UpsertB2bOrderVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertB2bOrder(
  id: id,
  orderRef: orderRef,
  sourceBranchId: sourceBranchId,
  destinationBranchId: destinationBranchId,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertB2bOrderData, UpsertB2bOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertB2bOrder(
  id: id,
  orderRef: orderRef,
  sourceBranchId: sourceBranchId,
  destinationBranchId: destinationBranchId,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertB2bOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String orderRef = ...;
String sourceBranchId = ...;
String destinationBranchId = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertB2bOrder(
  id: id,
  orderRef: orderRef,
  sourceBranchId: sourceBranchId,
  destinationBranchId: destinationBranchId,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteB2bOrder
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteB2bOrder(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteB2bOrderData, DeleteB2bOrderVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteB2bOrder(
  id: id,
);
DeleteB2bOrderData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteB2bOrder(
  id: id,
).ref();
ref.execute();
```


### UpsertB2bOrderItem
#### Required Arguments
```dart
String id = ...;
String orderId = ...;
String serialNo = ...;
String modelNo = ...;
int sortOrder = ...;
ExampleConnector.instance.upsertB2bOrderItem(
  id: id,
  orderId: orderId,
  serialNo: serialNo,
  modelNo: modelNo,
  sortOrder: sortOrder,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertB2bOrderItem, we created `UpsertB2bOrderItemBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertB2bOrderItemVariablesBuilder {
  ...
   UpsertB2bOrderItemVariablesBuilder stockItemId(String? t) {
   _stockItemId.value = t;
   return this;
  }
  UpsertB2bOrderItemVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertB2bOrderItem(
  id: id,
  orderId: orderId,
  serialNo: serialNo,
  modelNo: modelNo,
  sortOrder: sortOrder,
)
.stockItemId(stockItemId)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertB2bOrderItemData, UpsertB2bOrderItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertB2bOrderItem(
  id: id,
  orderId: orderId,
  serialNo: serialNo,
  modelNo: modelNo,
  sortOrder: sortOrder,
);
UpsertB2bOrderItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String orderId = ...;
String serialNo = ...;
String modelNo = ...;
int sortOrder = ...;

final ref = ExampleConnector.instance.upsertB2bOrderItem(
  id: id,
  orderId: orderId,
  serialNo: serialNo,
  modelNo: modelNo,
  sortOrder: sortOrder,
).ref();
ref.execute();
```


### DeleteB2bOrderItem
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteB2bOrderItem(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteB2bOrderItemData, DeleteB2bOrderItemVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteB2bOrderItem(
  id: id,
);
DeleteB2bOrderItemData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteB2bOrderItem(
  id: id,
).ref();
ref.execute();
```


### UpsertCrisRecord
#### Required Arguments
```dart
String id = ...;
String dNumber = ...;
String bNumber = ...;
double balance = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;
ExampleConnector.instance.upsertCrisRecord(
  id: id,
  dNumber: dNumber,
  bNumber: bNumber,
  balance: balance,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For UpsertCrisRecord, we created `UpsertCrisRecordBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class UpsertCrisRecordVariablesBuilder {
  ...
   UpsertCrisRecordVariablesBuilder customerId(String? t) {
   _customerId.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.upsertCrisRecord(
  id: id,
  dNumber: dNumber,
  bNumber: bNumber,
  balance: balance,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
)
.customerId(customerId)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<UpsertCrisRecordData, UpsertCrisRecordVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.upsertCrisRecord(
  id: id,
  dNumber: dNumber,
  bNumber: bNumber,
  balance: balance,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
);
UpsertCrisRecordData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String dNumber = ...;
String bNumber = ...;
double balance = ...;
String status = ...;
double createdAt = ...;
double updatedAt = ...;

final ref = ExampleConnector.instance.upsertCrisRecord(
  id: id,
  dNumber: dNumber,
  bNumber: bNumber,
  balance: balance,
  status: status,
  createdAt: createdAt,
  updatedAt: updatedAt,
).ref();
ref.execute();
```


### DeleteCrisRecord
#### Required Arguments
```dart
String id = ...;
ExampleConnector.instance.deleteCrisRecord(
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DeleteCrisRecordData, DeleteCrisRecordVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.deleteCrisRecord(
  id: id,
);
DeleteCrisRecordData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;

final ref = ExampleConnector.instance.deleteCrisRecord(
  id: id,
).ref();
ref.execute();
```


### InsertIncomingStockLog
#### Required Arguments
```dart
String id = ...;
String logType = ...;
String serialNo = ...;
String modelNo = ...;
String productName = ...;
String branchCode = ...;
double createdAt = ...;
ExampleConnector.instance.insertIncomingStockLog(
  id: id,
  logType: logType,
  serialNo: serialNo,
  modelNo: modelNo,
  productName: productName,
  branchCode: branchCode,
  createdAt: createdAt,
).execute();
```

#### Optional Arguments
We return a builder for each query. For InsertIncomingStockLog, we created `InsertIncomingStockLogBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class InsertIncomingStockLogVariablesBuilder {
  ...
   InsertIncomingStockLogVariablesBuilder referenceId(String? t) {
   _referenceId.value = t;
   return this;
  }
  InsertIncomingStockLogVariablesBuilder notes(String? t) {
   _notes.value = t;
   return this;
  }

  ...
}
ExampleConnector.instance.insertIncomingStockLog(
  id: id,
  logType: logType,
  serialNo: serialNo,
  modelNo: modelNo,
  productName: productName,
  branchCode: branchCode,
  createdAt: createdAt,
)
.referenceId(referenceId)
.notes(notes)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<InsertIncomingStockLogData, InsertIncomingStockLogVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ExampleConnector.instance.insertIncomingStockLog(
  id: id,
  logType: logType,
  serialNo: serialNo,
  modelNo: modelNo,
  productName: productName,
  branchCode: branchCode,
  createdAt: createdAt,
);
InsertIncomingStockLogData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String logType = ...;
String serialNo = ...;
String modelNo = ...;
String productName = ...;
String branchCode = ...;
double createdAt = ...;

final ref = ExampleConnector.instance.insertIncomingStockLog(
  id: id,
  logType: logType,
  serialNo: serialNo,
  modelNo: modelNo,
  productName: productName,
  branchCode: branchCode,
  createdAt: createdAt,
).ref();
ref.execute();
```

