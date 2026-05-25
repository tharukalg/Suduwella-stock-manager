library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'upsert_branch.dart';

part 'delete_branch.dart';

part 'upsert_product.dart';

part 'delete_product.dart';

part 'upsert_stock_item.dart';

part 'delete_stock_item.dart';

part 'upsert_customer.dart';

part 'delete_customer.dart';

part 'upsert_customer_photo.dart';

part 'delete_customer_photo.dart';

part 'upsert_sale.dart';

part 'delete_sale.dart';

part 'upsert_sale_customer.dart';

part 'delete_sale_customer.dart';

part 'upsert_easy_payment_bill.dart';

part 'delete_easy_payment_bill.dart';

part 'insert_easy_payment_transaction.dart';

part 'upsert_b2b_order.dart';

part 'delete_b2b_order.dart';

part 'upsert_b2b_order_item.dart';

part 'delete_b2b_order_item.dart';

part 'upsert_cris_record.dart';

part 'delete_cris_record.dart';

part 'insert_incoming_stock_log.dart';

part 'get_all_branches.dart';

part 'get_all_products.dart';

part 'get_product_by_model_no.dart';

part 'get_stock_by_branch.dart';

part 'get_stock_item_by_serial.dart';

part 'get_customer_by_nic.dart';

part 'get_customer_by_phone.dart';

part 'get_sale_by_bl_number.dart';

part 'get_active_sales_by_branch.dart';

part 'get_bill_by_number.dart';

part 'get_active_bills.dart';

part 'get_cris_record_by_d_number.dart';

part 'get_overdue_cris_records.dart';

part 'get_b2b_orders_by_branch.dart';

part 'get_incoming_log_by_branch.dart';

part 'upsert_device_registration.dart';

part 'delete_device_registration.dart';

part 'get_device_registration.dart';

part 'get_all_device_registrations.dart';







class ExampleConnector {
  
  
  UpsertBranchVariablesBuilder upsertBranch ({required String id, required String name, required bool isActive, }) {
    return UpsertBranchVariablesBuilder(dataConnect, id: id,name: name,isActive: isActive,);
  }
  
  
  DeleteBranchVariablesBuilder deleteBranch ({required String id, }) {
    return DeleteBranchVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertProductVariablesBuilder upsertProduct ({required String id, required String productName, required String modelNo, required double price, required double createdAt, required double updatedAt, }) {
    return UpsertProductVariablesBuilder(dataConnect, id: id,productName: productName,modelNo: modelNo,price: price,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteProductVariablesBuilder deleteProduct ({required String id, }) {
    return DeleteProductVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertStockItemVariablesBuilder upsertStockItem ({required String id, required String productId, required String branchCode, required String serialNo, required String status, required double createdAt, required double updatedAt, }) {
    return UpsertStockItemVariablesBuilder(dataConnect, id: id,productId: productId,branchCode: branchCode,serialNo: serialNo,status: status,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteStockItemVariablesBuilder deleteStockItem ({required String id, }) {
    return DeleteStockItemVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertCustomerVariablesBuilder upsertCustomer ({required String id, required String nic, required String name, required String phone, required double createdAt, required double updatedAt, }) {
    return UpsertCustomerVariablesBuilder(dataConnect, id: id,nic: nic,name: name,phone: phone,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteCustomerVariablesBuilder deleteCustomer ({required String id, }) {
    return DeleteCustomerVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertCustomerPhotoVariablesBuilder upsertCustomerPhoto ({required String id, required String customerId, required String photoType, required double createdAt, }) {
    return UpsertCustomerPhotoVariablesBuilder(dataConnect, id: id,customerId: customerId,photoType: photoType,createdAt: createdAt,);
  }
  
  
  DeleteCustomerPhotoVariablesBuilder deleteCustomerPhoto ({required String id, }) {
    return DeleteCustomerPhotoVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertSaleVariablesBuilder upsertSale ({required String id, required String blNumber, required String branchCode, required String stockItemId, required String paymentPlan, required double downPayment, required double totalAmount, required double financedAmount, required String status, required double createdAt, required double updatedAt, }) {
    return UpsertSaleVariablesBuilder(dataConnect, id: id,blNumber: blNumber,branchCode: branchCode,stockItemId: stockItemId,paymentPlan: paymentPlan,downPayment: downPayment,totalAmount: totalAmount,financedAmount: financedAmount,status: status,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteSaleVariablesBuilder deleteSale ({required String id, }) {
    return DeleteSaleVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertSaleCustomerVariablesBuilder upsertSaleCustomer ({required String id, required String saleId, required String customerId, required bool isPrimary, required int sortOrder, }) {
    return UpsertSaleCustomerVariablesBuilder(dataConnect, id: id,saleId: saleId,customerId: customerId,isPrimary: isPrimary,sortOrder: sortOrder,);
  }
  
  
  DeleteSaleCustomerVariablesBuilder deleteSaleCustomer ({required String id, }) {
    return DeleteSaleCustomerVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertEasyPaymentBillVariablesBuilder upsertEasyPaymentBill ({required String id, required String billNumber, required double currentBalance, required double totalPaid, required int remainingMonths, required double monthlyInstallment, required bool isActive, required String status, required double createdAt, required double updatedAt, }) {
    return UpsertEasyPaymentBillVariablesBuilder(dataConnect, id: id,billNumber: billNumber,currentBalance: currentBalance,totalPaid: totalPaid,remainingMonths: remainingMonths,monthlyInstallment: monthlyInstallment,isActive: isActive,status: status,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteEasyPaymentBillVariablesBuilder deleteEasyPaymentBill ({required String id, }) {
    return DeleteEasyPaymentBillVariablesBuilder(dataConnect, id: id,);
  }
  
  
  InsertEasyPaymentTransactionVariablesBuilder insertEasyPaymentTransaction ({required String id, required String billId, required String transactionType, required String branchCode, required double createdAt, }) {
    return InsertEasyPaymentTransactionVariablesBuilder(dataConnect, id: id,billId: billId,transactionType: transactionType,branchCode: branchCode,createdAt: createdAt,);
  }
  
  
  UpsertB2bOrderVariablesBuilder upsertB2bOrder ({required String id, required String orderRef, required String sourceBranchId, required String destinationBranchId, required String status, required double createdAt, required double updatedAt, }) {
    return UpsertB2bOrderVariablesBuilder(dataConnect, id: id,orderRef: orderRef,sourceBranchId: sourceBranchId,destinationBranchId: destinationBranchId,status: status,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteB2bOrderVariablesBuilder deleteB2bOrder ({required String id, }) {
    return DeleteB2bOrderVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertB2bOrderItemVariablesBuilder upsertB2bOrderItem ({required String id, required String orderId, required String serialNo, required String modelNo, required int sortOrder, }) {
    return UpsertB2bOrderItemVariablesBuilder(dataConnect, id: id,orderId: orderId,serialNo: serialNo,modelNo: modelNo,sortOrder: sortOrder,);
  }
  
  
  DeleteB2bOrderItemVariablesBuilder deleteB2bOrderItem ({required String id, }) {
    return DeleteB2bOrderItemVariablesBuilder(dataConnect, id: id,);
  }
  
  
  UpsertCrisRecordVariablesBuilder upsertCrisRecord ({required String id, required String dNumber, required String bNumber, required double balance, required String status, required double createdAt, required double updatedAt, }) {
    return UpsertCrisRecordVariablesBuilder(dataConnect, id: id,dNumber: dNumber,bNumber: bNumber,balance: balance,status: status,createdAt: createdAt,updatedAt: updatedAt,);
  }
  
  
  DeleteCrisRecordVariablesBuilder deleteCrisRecord ({required String id, }) {
    return DeleteCrisRecordVariablesBuilder(dataConnect, id: id,);
  }
  
  
  InsertIncomingStockLogVariablesBuilder insertIncomingStockLog ({required String id, required String logType, required String serialNo, required String modelNo, required String productName, required String branchCode, required double createdAt, }) {
    return InsertIncomingStockLogVariablesBuilder(dataConnect, id: id,logType: logType,serialNo: serialNo,modelNo: modelNo,productName: productName,branchCode: branchCode,createdAt: createdAt,);
  }
  
  
  GetAllBranchesVariablesBuilder getAllBranches () {
    return GetAllBranchesVariablesBuilder(dataConnect, );
  }
  
  
  GetAllProductsVariablesBuilder getAllProducts () {
    return GetAllProductsVariablesBuilder(dataConnect, );
  }
  
  
  GetProductByModelNoVariablesBuilder getProductByModelNo ({required String modelNo, }) {
    return GetProductByModelNoVariablesBuilder(dataConnect, modelNo: modelNo,);
  }
  
  
  GetStockByBranchVariablesBuilder getStockByBranch ({required String branchCode, }) {
    return GetStockByBranchVariablesBuilder(dataConnect, branchCode: branchCode,);
  }
  
  
  GetStockItemBySerialVariablesBuilder getStockItemBySerial ({required String serialNo, }) {
    return GetStockItemBySerialVariablesBuilder(dataConnect, serialNo: serialNo,);
  }
  
  
  GetCustomerByNicVariablesBuilder getCustomerByNic ({required String nic, }) {
    return GetCustomerByNicVariablesBuilder(dataConnect, nic: nic,);
  }
  
  
  GetCustomerByPhoneVariablesBuilder getCustomerByPhone ({required String phone, }) {
    return GetCustomerByPhoneVariablesBuilder(dataConnect, phone: phone,);
  }
  
  
  GetSaleByBlNumberVariablesBuilder getSaleByBlNumber ({required String blNumber, }) {
    return GetSaleByBlNumberVariablesBuilder(dataConnect, blNumber: blNumber,);
  }
  
  
  GetActiveSalesByBranchVariablesBuilder getActiveSalesByBranch ({required String branchCode, }) {
    return GetActiveSalesByBranchVariablesBuilder(dataConnect, branchCode: branchCode,);
  }
  
  
  GetBillByNumberVariablesBuilder getBillByNumber ({required String billNumber, }) {
    return GetBillByNumberVariablesBuilder(dataConnect, billNumber: billNumber,);
  }
  
  
  GetActiveBillsVariablesBuilder getActiveBills () {
    return GetActiveBillsVariablesBuilder(dataConnect, );
  }
  
  
  GetCrisRecordByDNumberVariablesBuilder getCrisRecordByDNumber ({required String dNumber, }) {
    return GetCrisRecordByDNumberVariablesBuilder(dataConnect, dNumber: dNumber,);
  }
  
  
  GetOverdueCrisRecordsVariablesBuilder getOverdueCrisRecords () {
    return GetOverdueCrisRecordsVariablesBuilder(dataConnect, );
  }
  
  
  GetB2bOrdersByBranchVariablesBuilder getB2bOrdersByBranch ({required String branchCode, }) {
    return GetB2bOrdersByBranchVariablesBuilder(dataConnect, branchCode: branchCode,);
  }
  
  
  GetIncomingLogByBranchVariablesBuilder getIncomingLogByBranch ({required String branchCode, }) {
    return GetIncomingLogByBranchVariablesBuilder(dataConnect, branchCode: branchCode,);
  }


  UpsertDeviceRegistrationVariablesBuilder upsertDeviceRegistration ({required String id, required String branchCode, required double createdAt, required double updatedAt, }) {
    return UpsertDeviceRegistrationVariablesBuilder(dataConnect, id: id, branchCode: branchCode, createdAt: createdAt, updatedAt: updatedAt,);
  }


  DeleteDeviceRegistrationVariablesBuilder deleteDeviceRegistration ({required String id, }) {
    return DeleteDeviceRegistrationVariablesBuilder(dataConnect, id: id,);
  }


  GetDeviceRegistrationVariablesBuilder getDeviceRegistration ({required String id, }) {
    return GetDeviceRegistrationVariablesBuilder(dataConnect, id: id,);
  }


  GetAllDeviceRegistrationsVariablesBuilder getAllDeviceRegistrations () {
    return GetAllDeviceRegistrationsVariablesBuilder(dataConnect,);
  }


  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'suduwella-stock-manager-f7d90-2-service',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return ExampleConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
