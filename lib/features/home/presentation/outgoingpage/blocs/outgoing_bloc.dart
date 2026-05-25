import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/database/daos/app_settings_dao.dart';
import '../../../../../core/database/daos/b2b_dao.dart';
import '../../../../../core/database/daos/customer_dao.dart';
import '../../../../../core/database/daos/easy_payment_dao.dart';
import '../../../../../core/database/daos/product_dao.dart';
import '../../../../../core/database/daos/sale_dao.dart';
import '../../../../../core/database/daos/stock_item_dao.dart';

part 'outgoing_event.dart';
part 'outgoing_state.dart';

class OutgoingBloc extends Bloc<OutgoingEvent, OutgoingState> {
  final SaleDao _saleDao;
  final CustomerDao _customerDao;
  final StockItemDao _stockItemDao;
  final EasyPaymentDao _easyPaymentDao;
  final B2bDao _b2bDao;
  final AppSettingsDao _appSettingsDao;
  final ProductDao _productDao;

  OutgoingBloc({
    required SaleDao saleDao,
    required CustomerDao customerDao,
    required StockItemDao stockItemDao,
    required EasyPaymentDao easyPaymentDao,
    required B2bDao b2bDao,
    required AppSettingsDao appSettingsDao,
    required ProductDao productDao,
  })  : _saleDao = saleDao,
        _customerDao = customerDao,
        _stockItemDao = stockItemDao,
        _easyPaymentDao = easyPaymentDao,
        _b2bDao = b2bDao,
        _appSettingsDao = appSettingsDao,
        _productDao = productDao,
        super(OutgoingInitial()) {
    on<OutgoingInitEvent>(_onInit);

    // ── Tab: New Sale ──────────────────────────────────────────────────────
    on<ModelNoChangedEvent>(_onModelNoChanged);
    on<SerialNoChangedEvent>(_onSerialNoChanged);
    on<BLNumberChangedEvent>(_onBLNumberChanged);
    on<CustomerIdChangedEvent>(_onCustomerIdChanged);
    on<LookupCustomerByNicEvent>(_onLookupCustomerByNic);
    on<CustomerNameChangedEvent>(_onCustomerNameChanged);
    on<CustomerPhoneChangedEvent>(_onCustomerPhoneChanged);
    on<CustomerDescriptionChangedEvent>(_onCustomerDescriptionChanged);
    on<VerifyCustomerIdEvent>(_onVerifyCustomerId);
    on<VerifyCustomerPhoneEvent>(_onVerifyCustomerPhone);
    on<AddCustomerEvent>(_onAddCustomer);
    on<RemoveCustomerEvent>(_onRemoveCustomer);
    on<AddCustomerPhotoEvent>(_onAddCustomerPhoto);
    on<RemoveCustomerPhotoEvent>(_onRemoveCustomerPhoto);
    on<AddCustomerSelfieEvent>(_onAddCustomerSelfie);
    on<RemoveCustomerSelfieEvent>(_onRemoveCustomerSelfie);
    on<PaymentPlanChangedEvent>(_onPaymentPlanChanged);
    on<DownPaymentChangedEvent>(_onDownPaymentChanged);
    on<DurationChangedEvent>(_onDurationChanged);
    on<SubmitOutgoingEvent>(_onSubmitNewSale);

    // ── Tab: Easy Payment ──────────────────────────────────────────────────
    on<EasyPaymentSearchQueryChangedEvent>(_onEasyPaymentSearchQueryChanged);
    on<EasyPaymentSearchEvent>(_onEasyPaymentSearch);
    on<EasyPaymentContinueEvent>(_onEasyPaymentContinue);
    on<EasyPaymentEndEvent>(_onEasyPaymentEnd);
    on<EasyPaymentRemainingMonthsChangedEvent>(
        _onEasyPaymentRemainingMonthsChanged);
    on<EasyPaymentInstallmentChangedEvent>(_onEasyPaymentInstallmentChanged);
    on<EasyPaymentUpdatePlanEvent>(_onEasyPaymentUpdatePlan);
    on<EasyPaymentFullySettledEvent>(_onEasyPaymentFullySettled);
    on<EasyPaymentItemRecoveredEvent>(_onEasyPaymentItemRecovered);
    on<EasyPaymentResetEvent>(_onEasyPaymentReset);

    // ── Tab: B2B ───────────────────────────────────────────────────────────
    on<B2BDestinationBranchChangedEvent>(_onB2BDestinationBranchChanged);
    on<B2BModelNoChangedEvent>(_onB2BModelNoChanged);
    on<B2BSerialNoChangedEvent>(_onB2BSerialNoChanged);
    on<B2BNotesChangedEvent>(_onB2BNotesChanged);
    on<B2BAddItemEvent>(_onB2BAddItem);
    on<B2BRemoveItemEvent>(_onB2BRemoveItem);
    on<SubmitB2BEvent>(_onSubmitB2B);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  OutgoingLoaded get _loaded =>
      state is OutgoingLoaded ? state as OutgoingLoaded : OutgoingLoaded();

  List<CustomerEntry> _updateCustomer(
    int index,
    CustomerEntry Function(CustomerEntry) update,
  ) {
    final list = List<CustomerEntry>.from(_loaded.newSale.customers);
    if (index >= 0 && index < list.length) list[index] = update(list[index]);
    return list;
  }

  PaymentPlan _toDaoPaymentPlan(PaymentPlanType plan) => switch (plan) {
        PaymentPlanType.interestFree => PaymentPlan.interestFree,
        PaymentPlanType.directEasyPayment => PaymentPlan.directEasyPayment,
      };

  EasyPaymentBillDetails _toBillDetails(EasyPaymentBillModel m) =>
      EasyPaymentBillDetails(
        billNumber: m.billNumber,
        currentBalance: m.currentBalance,
        lastPaymentAmount: m.lastPaymentAmount ?? 0,
        lastPaymentDate: m.lastPaymentDate != null
            ? DateTime.fromMillisecondsSinceEpoch(m.lastPaymentDate!)
            : DateTime.now(),
        totalPaid: m.totalPaid,
        isActive: m.isActive,
      );

  // =========================================================================
  // Tab: New Sale
  // =========================================================================

  void _onInit(OutgoingInitEvent e, Emitter<OutgoingState> emit) =>
      emit(OutgoingLoaded());

  Future<void> _onModelNoChanged(
      ModelNoChangedEvent e, Emitter<OutgoingState> emit) async {
    final trimmed = e.value.trim();
    final product =
        trimmed.isNotEmpty ? await _productDao.getByModelNo(trimmed) : null;
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(
          modelNo: e.value,
          productName: product?.productName ?? '',
          totalAmount: product?.price ?? 0,
        )));
  }

  void _onSerialNoChanged(
          SerialNoChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          newSale: _loaded.newSale.copyWith(serialNo: e.value)));

  void _onBLNumberChanged(
          BLNumberChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          newSale: _loaded.newSale.copyWith(blNumber: e.value)));

  void _onCustomerIdChanged(
      CustomerIdChangedEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(e.customerIndex,
        (c) => c.copyWith(id: e.value, idStatus: VerificationStatus.idle));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  Future<void> _onLookupCustomerByNic(
      LookupCustomerByNicEvent e, Emitter<OutgoingState> emit) async {
    final nic = _loaded.newSale.customers[e.customerIndex].id.trim();
    if (nic.isEmpty) return;

    final customer = await _customerDao.getByNic(nic);
    if (customer == null) return;

    final updated = _updateCustomer(
      e.customerIndex,
      (c) => c.copyWith(
        name: customer.name,
        phone: customer.phone,
        description: customer.description ?? '',
        idStatus: VerificationStatus.verified,
      ),
    );
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onCustomerNameChanged(
      CustomerNameChangedEvent e, Emitter<OutgoingState> emit) {
    final updated =
        _updateCustomer(e.customerIndex, (c) => c.copyWith(name: e.value));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onCustomerPhoneChanged(
      CustomerPhoneChangedEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(
        e.customerIndex,
        (c) =>
            c.copyWith(phone: e.value, phoneStatus: VerificationStatus.idle));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onCustomerDescriptionChanged(
      CustomerDescriptionChangedEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(
        e.customerIndex, (c) => c.copyWith(description: e.value));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  // ID / phone verification will eventually call an external API.
  // For now they use a short delay to simulate network latency.
  Future<void> _onVerifyCustomerId(
      VerifyCustomerIdEvent e, Emitter<OutgoingState> emit) async {
    var updated = _updateCustomer(e.customerIndex,
        (c) => c.copyWith(idStatus: VerificationStatus.loading));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
    await Future.delayed(const Duration(seconds: 1));
    updated = _updateCustomer(e.customerIndex,
        (c) => c.copyWith(idStatus: VerificationStatus.verified));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  Future<void> _onVerifyCustomerPhone(
      VerifyCustomerPhoneEvent e, Emitter<OutgoingState> emit) async {
    var updated = _updateCustomer(e.customerIndex,
        (c) => c.copyWith(phoneStatus: VerificationStatus.loading));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
    await Future.delayed(const Duration(seconds: 1));
    updated = _updateCustomer(e.customerIndex,
        (c) => c.copyWith(phoneStatus: VerificationStatus.verified));
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onAddCustomer(AddCustomerEvent e, Emitter<OutgoingState> emit) {
    final list = List<CustomerEntry>.from(_loaded.newSale.customers)
      ..add(const CustomerEntry());
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: list)));
  }

  void _onRemoveCustomer(RemoveCustomerEvent e, Emitter<OutgoingState> emit) {
    if (_loaded.newSale.customers.length <= 1) return;
    final list = List<CustomerEntry>.from(_loaded.newSale.customers)
      ..removeAt(e.index);
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: list)));
  }

  void _onAddCustomerPhoto(
      AddCustomerPhotoEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(e.customerIndex, (c) {
      final photos = List<String>.from(c.photoPaths)..add(e.imagePath);
      return c.copyWith(photoPaths: photos);
    });
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onRemoveCustomerPhoto(
      RemoveCustomerPhotoEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(e.customerIndex, (c) {
      final photos = List<String>.from(c.photoPaths)..removeAt(e.photoIndex);
      return c.copyWith(photoPaths: photos);
    });
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onAddCustomerSelfie(
      AddCustomerSelfieEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(e.customerIndex, (c) {
      final selfies = List<String>.from(c.selfiePaths)..add(e.imagePath);
      return c.copyWith(selfiePaths: selfies);
    });
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onRemoveCustomerSelfie(
      RemoveCustomerSelfieEvent e, Emitter<OutgoingState> emit) {
    final updated = _updateCustomer(e.customerIndex, (c) {
      final selfies = List<String>.from(c.selfiePaths)
        ..removeAt(e.photoIndex);
      return c.copyWith(selfiePaths: selfies);
    });
    emit(_loaded.copyWith(
        newSale: _loaded.newSale.copyWith(customers: updated)));
  }

  void _onPaymentPlanChanged(
          PaymentPlanChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          newSale: _loaded.newSale.copyWith(selectedPlan: e.plan)));

  void _onDownPaymentChanged(
          DownPaymentChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          newSale: _loaded.newSale
              .copyWith(downPayment: double.tryParse(e.value) ?? 0)));

  void _onDurationChanged(
          DurationChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          newSale: _loaded.newSale.copyWith(durationMonths: e.months)));

  Future<void> _onSubmitNewSale(
      SubmitOutgoingEvent e, Emitter<OutgoingState> emit) async {
    final sale = _loaded.newSale;
    emit(_loaded.copyWith(newSale: sale.copyWith(isSubmitting: true)));

    try {
      final branchCode = await _appSettingsDao.getActiveBranch();
      final productName = sale.productName.trim().isEmpty
          ? sale.modelNo.trim()
          : sale.productName.trim();

      // 1. Upsert product by model number.
      var product = await _productDao.getByModelNo(sale.modelNo.trim());
      if (product == null) {
        product = ProductModel.create(
          productName: productName,
          modelNo: sale.modelNo.trim(),
        );
        await _productDao.insert(product);
      }

      // 2. Find existing stock item; create one if it hasn't been logged yet.
      var stockItem = await _stockItemDao.getBySerialNo(sale.serialNo.trim());
      if (stockItem == null) {
        stockItem = StockItemModel.create(
          productId: product.id,
          serialNo: sale.serialNo.trim(),
          branchCode: branchCode,
        );
        await _stockItemDao.insert(stockItem);
      }

      // 3. Upsert each customer and save their photos.
      final saleModel = SaleModel.create(
        blNumber: sale.blNumber.trim(),
        branchCode: branchCode,
        stockItemId: stockItem.id,
        paymentPlan: _toDaoPaymentPlan(sale.selectedPlan),
        downPayment: sale.downPayment,
        totalAmount: sale.totalAmount,
        financedAmount: sale.financedAmount,
        durationMonths: sale.selectedPlan == PaymentPlanType.directEasyPayment
            ? sale.durationMonths
            : null,
        monthlyInstallment:
            sale.selectedPlan == PaymentPlanType.directEasyPayment
                ? sale.monthlyInstallment
                : null,
      );

      final saleCustomers = <SaleCustomerModel>[];
      for (var i = 0; i < sale.customers.length; i++) {
        final entry = sale.customers[i];
        final customer = CustomerModel.create(
          nic: entry.id.trim(),
          name: entry.name.trim(),
          phone: entry.phone.trim(),
          description: entry.description.trim().isEmpty
              ? null
              : entry.description.trim(),
        );
        final customerId = await _customerDao.insertIfNew(customer);

        for (final path in entry.photoPaths) {
          await _customerDao.insertPhoto(CustomerPhotoModel.create(
            customerId: customerId,
            photoType: 'id_photo',
            localPath: path,
          ));
        }
        for (final path in entry.selfiePaths) {
          await _customerDao.insertPhoto(CustomerPhotoModel.create(
            customerId: customerId,
            photoType: 'selfie',
            localPath: path,
          ));
        }

        saleCustomers.add(SaleCustomerModel.create(
          saleId: saleModel.id,
          customerId: customerId,
          isPrimary: i == 0,
          sortOrder: i,
        ));
      }

      // 4. Persist sale + customers atomically.
      await _saleDao.insertSale(saleModel, saleCustomers);

      // 5. Mark unit as sold.
      await _stockItemDao.updateStatus(stockItem.id, StockStatus.sold);

      // 6. Create an easy payment bill for financed plans.
      if (sale.selectedPlan == PaymentPlanType.directEasyPayment) {
        final bill = EasyPaymentBillModel.create(
          billNumber: sale.blNumber.trim(),
          saleId: saleModel.id,
          currentBalance: sale.financedAmount,
          remainingMonths: sale.durationMonths,
          monthlyInstallment: sale.monthlyInstallment,
        );
        await _easyPaymentDao.insert(bill);
      }

      emit(OutgoingSubmitSuccess('New Sale'));
    } catch (err) {
      emit(_loaded.copyWith(newSale: sale.copyWith(isSubmitting: false)));
      emit(OutgoingError(err.toString()));
    }
  }

  // =========================================================================
  // Tab: Easy Payment
  // =========================================================================

  void _onEasyPaymentSearchQueryChanged(
          EasyPaymentSearchQueryChangedEvent e,
          Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          easyPayment:
              _loaded.easyPayment.copyWith(searchQuery: e.value)));

  Future<void> _onEasyPaymentSearch(
      EasyPaymentSearchEvent e, Emitter<OutgoingState> emit) async {
    final query = _loaded.easyPayment.searchQuery.trim();
    if (query.isEmpty) return;

    emit(_loaded.copyWith(
        easyPayment: _loaded.easyPayment
            .copyWith(status: EasyPaymentStatus.searching)));

    final bill = await _easyPaymentDao.getByBillNumber(query);

    if (bill == null) {
      emit(_loaded.copyWith(
          easyPayment: _loaded.easyPayment
              .copyWith(status: EasyPaymentStatus.notFound)));
      return;
    }

    emit(_loaded.copyWith(
        easyPayment: _loaded.easyPayment.copyWith(
          status: EasyPaymentStatus.found,
          bill: _toBillDetails(bill),
          remainingMonths: bill.remainingMonths,
          monthlyInstallment: bill.monthlyInstallment,
        )));
  }

  void _onEasyPaymentContinue(
          EasyPaymentContinueEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          easyPayment: _loaded.easyPayment
              .copyWith(status: EasyPaymentStatus.continued)));

  void _onEasyPaymentEnd(
          EasyPaymentEndEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          easyPayment: _loaded.easyPayment
              .copyWith(status: EasyPaymentStatus.submitting)));

  void _onEasyPaymentRemainingMonthsChanged(
          EasyPaymentRemainingMonthsChangedEvent e,
          Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          easyPayment:
              _loaded.easyPayment.copyWith(remainingMonths: e.months)));

  void _onEasyPaymentInstallmentChanged(
          EasyPaymentInstallmentChangedEvent e,
          Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          easyPayment:
              _loaded.easyPayment.copyWith(monthlyInstallment: e.amount)));

  Future<void> _onEasyPaymentUpdatePlan(
      EasyPaymentUpdatePlanEvent e, Emitter<OutgoingState> emit) async {
    final ep = _loaded.easyPayment;
    final billNumber = ep.bill?.billNumber;
    if (billNumber == null) return;

    final bill = await _easyPaymentDao.getByBillNumber(billNumber);
    if (bill == null) return;

    final branchCode = await _appSettingsDao.getActiveBranch();
    await _easyPaymentDao.updatePlan(
      billId: bill.id,
      remainingMonths: ep.remainingMonths,
      monthlyInstallment: ep.monthlyInstallment,
      branchCode: branchCode,
    );
    emit(OutgoingSubmitSuccess('Plan Updated'));
  }

  Future<void> _onEasyPaymentFullySettled(
      EasyPaymentFullySettledEvent e, Emitter<OutgoingState> emit) async {
    final billNumber = _loaded.easyPayment.bill?.billNumber;
    if (billNumber == null) return;

    final bill = await _easyPaymentDao.getByBillNumber(billNumber);
    if (bill == null) return;

    final branchCode = await _appSettingsDao.getActiveBranch();
    await _easyPaymentDao.closeOut(
      billId: bill.id,
      outcome: BillStatus.settled,
      branchCode: branchCode,
    );
    emit(OutgoingSubmitSuccess('Fully Settled'));
  }

  Future<void> _onEasyPaymentItemRecovered(
      EasyPaymentItemRecoveredEvent e, Emitter<OutgoingState> emit) async {
    final billNumber = _loaded.easyPayment.bill?.billNumber;
    if (billNumber == null) return;

    final bill = await _easyPaymentDao.getByBillNumber(billNumber);
    if (bill == null) return;

    final branchCode = await _appSettingsDao.getActiveBranch();
    await _easyPaymentDao.closeOut(
      billId: bill.id,
      outcome: BillStatus.recovered,
      branchCode: branchCode,
    );
    emit(OutgoingSubmitSuccess('Item Recovered'));
  }

  void _onEasyPaymentReset(
          EasyPaymentResetEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(easyPayment: const EasyPaymentFormState()));

  // =========================================================================
  // Tab: B2B
  // =========================================================================

  void _onB2BDestinationBranchChanged(
          B2BDestinationBranchChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(
          b2b: _loaded.b2b.copyWith(destinationBranch: e.branch)));

  void _onB2BModelNoChanged(
          B2BModelNoChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(b2b: _loaded.b2b.copyWith(modelNo: e.value)));

  void _onB2BSerialNoChanged(
          B2BSerialNoChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(b2b: _loaded.b2b.copyWith(serialNo: e.value)));

  void _onB2BNotesChanged(
          B2BNotesChangedEvent e, Emitter<OutgoingState> emit) =>
      emit(_loaded.copyWith(b2b: _loaded.b2b.copyWith(notes: e.value)));

  void _onB2BAddItem(B2BAddItemEvent e, Emitter<OutgoingState> emit) {
    final b2b = _loaded.b2b;
    if (b2b.modelNo.trim().isEmpty || b2b.serialNo.trim().isEmpty) return;
    final newItem = B2BCartItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      modelNo: b2b.modelNo.trim(),
      serialNo: b2b.serialNo.trim(),
      notes: b2b.notes.trim(),
    );
    emit(_loaded.copyWith(
      b2b: b2b.copyWith(
        items: [...b2b.items, newItem],
        modelNo: '',
        serialNo: '',
        notes: '',
      ),
    ));
  }

  void _onB2BRemoveItem(B2BRemoveItemEvent e, Emitter<OutgoingState> emit) {
    final items =
        _loaded.b2b.items.where((item) => item.id != e.itemId).toList();
    emit(_loaded.copyWith(b2b: _loaded.b2b.copyWith(items: items)));
  }

  Future<void> _onSubmitB2B(
      SubmitB2BEvent e, Emitter<OutgoingState> emit) async {
    final b2b = _loaded.b2b;
    emit(_loaded.copyWith(b2b: b2b.copyWith(isSubmitting: true)));

    try {
      final branchCode = await _appSettingsDao.getActiveBranch();
      final order = B2bOrderModel.create(
        sourceBranch: branchCode,
        destinationBranch: b2b.destinationBranch,
      );

      final items = b2b.items.asMap().entries.map((entry) {
        return B2bOrderItemModel.create(
          orderId: order.id,
          serialNo: entry.value.serialNo,
          modelNo: entry.value.modelNo,
          notes: entry.value.notes.isEmpty ? null : entry.value.notes,
          sortOrder: entry.key,
        );
      }).toList();

      await _b2bDao.insertOrder(order, items);

      // Update stock_items to b2b_transit if they exist in local DB.
      for (final item in b2b.items) {
        final stockItem =
            await _stockItemDao.getBySerialNo(item.serialNo.trim());
        if (stockItem != null) {
          await _stockItemDao.updateStatus(stockItem.id, StockStatus.b2bTransit);
        }
      }

      emit(OutgoingSubmitSuccess('B2B'));
    } catch (err) {
      emit(_loaded.copyWith(b2b: b2b.copyWith(isSubmitting: false)));
      emit(OutgoingError(err.toString()));
    }
  }
}