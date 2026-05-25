# Basic Usage

```dart
ExampleConnector.instance.UpsertBranch(upsertBranchVariables).execute();
ExampleConnector.instance.DeleteBranch(deleteBranchVariables).execute();
ExampleConnector.instance.UpsertProduct(upsertProductVariables).execute();
ExampleConnector.instance.DeleteProduct(deleteProductVariables).execute();
ExampleConnector.instance.UpsertStockItem(upsertStockItemVariables).execute();
ExampleConnector.instance.DeleteStockItem(deleteStockItemVariables).execute();
ExampleConnector.instance.UpsertCustomer(upsertCustomerVariables).execute();
ExampleConnector.instance.DeleteCustomer(deleteCustomerVariables).execute();
ExampleConnector.instance.UpsertCustomerPhoto(upsertCustomerPhotoVariables).execute();
ExampleConnector.instance.DeleteCustomerPhoto(deleteCustomerPhotoVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ExampleConnector.instance.InsertIncomingStockLog({ ... })
.referenceId(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

