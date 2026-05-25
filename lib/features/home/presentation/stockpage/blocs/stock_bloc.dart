import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/database/daos/app_settings_dao.dart';
import '../../../../../core/database/daos/incoming_stock_dao.dart';
import '../../../../../core/database/daos/product_dao.dart';
import '../../../../../core/database/daos/stock_item_dao.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockItemDao _stockItemDao;
  final ProductDao _productDao;
  final IncomingStockDao _incomingStockDao;
  final AppSettingsDao _appSettingsDao;

  StockBloc({
    required StockItemDao stockItemDao,
    required ProductDao productDao,
    required IncomingStockDao incomingStockDao,
    required AppSettingsDao appSettingsDao,
  })  : _stockItemDao = stockItemDao,
        _productDao = productDao,
        _incomingStockDao = incomingStockDao,
        _appSettingsDao = appSettingsDao,
        super(StockInitial()) {
    on<StockInitialLoadEvent>(_onInitialLoad);
    on<StockSearchQueryChangedEvent>(_onSearchQueryChanged);
    on<IncomingTabChangedEvent>(_onIncomingTabChanged);
    on<NewItemSerialNoChangedEvent>(_onNewItemSerialNoChanged);
    on<NewItemModelNoChangedEvent>(_onNewItemModelNoChanged);
    on<NewItemProductNameChangedEvent>(_onNewItemProductNameChanged);
    on<NewItemPriceChangedEvent>(_onNewItemPriceChanged);
    on<SubmitNewItemEvent>(_onSubmitNewItem);
    on<RecItemSerialNoChangedEvent>(_onRecItemSerialNoChanged);
    on<RecItemModelNoChangedEvent>(_onRecItemModelNoChanged);
    on<RecItemProductNameChangedEvent>(_onRecItemProductNameChanged);
    on<RecItemPriceChangedEvent>(_onRecItemPriceChanged);
    on<SubmitRecoveredItemEvent>(_onSubmitRecoveredItem);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  StockLoaded get _loaded =>
      state is StockLoaded ? state as StockLoaded : StockLoaded();

  // Groups flat (product, branch, count) rows into StockItem(branchStock map).
  List<StockItem> _aggregateRows(List<StockSummaryRow> rows) {
    final buckets = <String, _ProductBucket>{};
    for (final row in rows) {
      buckets.putIfAbsent(
        row.productId,
        () => _ProductBucket(
          productName: row.productName,
          modelNo: row.modelNo,
          imagePath: row.imagePath,
        ),
      );
      if (row.branchCode.isNotEmpty && row.unitCount > 0) {
        buckets[row.productId]!.branchStock[row.branchCode] = row.unitCount;
      }
    }
    return buckets.entries
        .map((e) => StockItem(
              id: e.key,
              productName: e.value.productName,
              modelNo: e.value.modelNo,
              imagePath: e.value.imagePath,
              branchStock: Map.unmodifiable(e.value.branchStock),
            ))
        .toList();
  }

  Future<List<StockItem>> _loadItems() async {
    final rows = await _stockItemDao.getStockSummary();
    return _aggregateRows(rows);
  }

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> _onInitialLoad(
      StockInitialLoadEvent e, Emitter<StockState> emit) async {
    final branchCode = await _appSettingsDao.getActiveBranch();
    final items = await _loadItems();
    emit(StockLoaded(allItems: items, activeBranch: branchCode));
  }

  // ── Search ────────────────────────────────────────────────────────────────

  void _onSearchQueryChanged(
      StockSearchQueryChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(searchQuery: e.query));
  }

  // ── Incoming › Tab ────────────────────────────────────────────────────────

  void _onIncomingTabChanged(
      IncomingTabChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(activeTab: e.tab)));
  }

  // ── Incoming › New Item fields ────────────────────────────────────────────

  void _onNewItemSerialNoChanged(
      NewItemSerialNoChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(newSerialNo: e.value)));
  }

  void _onNewItemModelNoChanged(
      NewItemModelNoChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(newModelNo: e.value)));
  }

  void _onNewItemProductNameChanged(
      NewItemProductNameChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(newProductName: e.value)));
  }

  void _onNewItemPriceChanged(
      NewItemPriceChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(newPrice: e.value)));
  }

  // ── Incoming › Submit New Item ────────────────────────────────────────────

  Future<void> _onSubmitNewItem(
      SubmitNewItemEvent e, Emitter<StockState> emit) async {
    final form = _loaded.incomingForm;
    emit(_loaded.copyWith(
        incomingForm: form.copyWith(newIsSubmitting: true)));

    try {
      final branchCode = await _appSettingsDao.getActiveBranch();
      final productName =
          form.newProductName.trim().isEmpty ? form.newModelNo : form.newProductName.trim();
      final price = double.tryParse(form.newPrice.trim()) ?? 0;

      // Upsert product by model number.
      var product = await _productDao.getByModelNo(form.newModelNo.trim());
      if (product == null) {
        product = ProductModel.create(
          productName: productName,
          modelNo: form.newModelNo.trim(),
          price: price,
        );
        await _productDao.insert(product);
      }

      // Create stock item (ignore duplicate serial numbers silently).
      final stockItem = StockItemModel.create(
        productId: product.id,
        serialNo: form.newSerialNo.trim(),
        branchCode: branchCode,
      );
      await _stockItemDao.insert(stockItem);

      // Append audit log entry.
      await _incomingStockDao.insert(IncomingStockLogModel.create(
        logType: IncomingLogType.newItem,
        serialNo: form.newSerialNo.trim(),
        modelNo: form.newModelNo.trim(),
        productName: productName,
        branchCode: branchCode,
      ));

      final items = await _loadItems();
      emit(_loaded.copyWith(
        allItems: items,
        incomingForm: const IncomingStockForm(),
        justSubmittedMessage: 'New item added to stock',
      ));
    } catch (_) {
      emit(_loaded.copyWith(
          incomingForm: form.copyWith(newIsSubmitting: false)));
    }
  }

  // ── Incoming › Recovered Item fields ─────────────────────────────────────

  void _onRecItemSerialNoChanged(
      RecItemSerialNoChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(recSerialNo: e.value)));
  }

  void _onRecItemModelNoChanged(
      RecItemModelNoChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(recModelNo: e.value)));
  }

  void _onRecItemProductNameChanged(
      RecItemProductNameChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(recProductName: e.value)));
  }

  void _onRecItemPriceChanged(
      RecItemPriceChangedEvent e, Emitter<StockState> emit) {
    emit(_loaded.copyWith(
        incomingForm: _loaded.incomingForm.copyWith(recPrice: e.value)));
  }

  // ── Incoming › Submit Recovered Item ─────────────────────────────────────

  Future<void> _onSubmitRecoveredItem(
      SubmitRecoveredItemEvent e, Emitter<StockState> emit) async {
    final form = _loaded.incomingForm;
    emit(_loaded.copyWith(
        incomingForm: form.copyWith(recIsSubmitting: true)));

    try {
      final branchCode = await _appSettingsDao.getActiveBranch();
      final productName =
          form.recProductName.trim().isEmpty ? form.recModelNo : form.recProductName.trim();
      final price = double.tryParse(form.recPrice.trim()) ?? 0;

      // If the serial is already tracked, mark it recovered; otherwise create it.
      final existing = await _stockItemDao.getBySerialNo(form.recSerialNo.trim());
      if (existing != null) {
        await _stockItemDao.updateStatus(existing.id, StockStatus.recovered);
      } else {
        var product = await _productDao.getByModelNo(form.recModelNo.trim());
        if (product == null) {
          product = ProductModel.create(
            productName: productName,
            modelNo: form.recModelNo.trim(),
            price: price,
          );
          await _productDao.insert(product);
        }
        final stockItem = StockItemModel.create(
          productId: product.id,
          serialNo: form.recSerialNo.trim(),
          branchCode: branchCode,
        );
        await _stockItemDao.insert(stockItem);
        await _stockItemDao.updateStatus(stockItem.id, StockStatus.recovered);
      }

      // Append audit log entry.
      await _incomingStockDao.insert(IncomingStockLogModel.create(
        logType: IncomingLogType.recoveredItem,
        serialNo: form.recSerialNo.trim(),
        modelNo: form.recModelNo.trim(),
        productName: productName,
        branchCode: branchCode,
      ));

      final items = await _loadItems();
      emit(_loaded.copyWith(
        allItems: items,
        incomingForm: const IncomingStockForm(),
        justSubmittedMessage: 'Recovered item logged',
      ));
    } catch (_) {
      emit(_loaded.copyWith(
          incomingForm: form.copyWith(recIsSubmitting: false)));
    }
  }
}

// Private helper — not exposed outside this file.
class _ProductBucket {
  final String productName;
  final String modelNo;
  final String? imagePath;
  final Map<String, int> branchStock = {};

  _ProductBucket({
    required this.productName,
    required this.modelNo,
    this.imagePath,
  });
}