part of 'stock_bloc.dart';

enum IncomingStockTab { newItem, recoveredItem }

// ── Stock Item ────────────────────────────────────────────────────────────────

class StockItem {
  final String id;
  final String productName;
  final String modelNo;
  final String? imagePath;
  final Map<String, int> branchStock;

  const StockItem({
    required this.id,
    required this.productName,
    required this.modelNo,
    this.imagePath,
    this.branchStock = const {},
  });

  int get totalUnits =>
      branchStock.values.fold(0, (sum, v) => sum + v);
}

// ── Incoming Stock Form ───────────────────────────────────────────────────────

class IncomingStockForm {
  final IncomingStockTab activeTab;

  final String newSerialNo;
  final String newModelNo;
  final String newProductName;
  final String newPrice;
  final bool newIsSubmitting;

  final String recSerialNo;
  final String recModelNo;
  final String recProductName;
  final String recPrice;
  final bool recIsSubmitting;

  const IncomingStockForm({
    this.activeTab = IncomingStockTab.newItem,
    this.newSerialNo = '',
    this.newModelNo = '',
    this.newProductName = '',
    this.newPrice = '',
    this.newIsSubmitting = false,
    this.recSerialNo = '',
    this.recModelNo = '',
    this.recProductName = '',
    this.recPrice = '',
    this.recIsSubmitting = false,
  });

  IncomingStockForm copyWith({
    IncomingStockTab? activeTab,
    String? newSerialNo,
    String? newModelNo,
    String? newProductName,
    String? newPrice,
    bool? newIsSubmitting,
    String? recSerialNo,
    String? recModelNo,
    String? recProductName,
    String? recPrice,
    bool? recIsSubmitting,
  }) {
    return IncomingStockForm(
      activeTab: activeTab ?? this.activeTab,
      newSerialNo: newSerialNo ?? this.newSerialNo,
      newModelNo: newModelNo ?? this.newModelNo,
      newProductName: newProductName ?? this.newProductName,
      newPrice: newPrice ?? this.newPrice,
      newIsSubmitting: newIsSubmitting ?? this.newIsSubmitting,
      recSerialNo: recSerialNo ?? this.recSerialNo,
      recModelNo: recModelNo ?? this.recModelNo,
      recProductName: recProductName ?? this.recProductName,
      recPrice: recPrice ?? this.recPrice,
      recIsSubmitting: recIsSubmitting ?? this.recIsSubmitting,
    );
  }
}

// ── Root States ───────────────────────────────────────────────────────────────

@immutable
sealed class StockState {}

final class StockInitial extends StockState {}

final class StockLoaded extends StockState {
  final String searchQuery;
  final List<StockItem> allItems;
  final String activeBranch;
  final IncomingStockForm incomingForm;
  // Non-null for one emission after a successful submit → UI listens then shows snackbar
  final String? justSubmittedMessage;

  List<StockItem> get filteredItems {
    final q = searchQuery.toLowerCase().trim();
    if (q.isEmpty) return allItems;
    return allItems.where((item) {
      return item.productName.toLowerCase().contains(q) ||
          item.modelNo.toLowerCase().contains(q);
    }).toList();
  }

   StockLoaded({
    this.searchQuery = '',
    this.allItems = const [],
    this.activeBranch = 'KH',
    this.incomingForm = const IncomingStockForm(),
    this.justSubmittedMessage,
  });

  StockLoaded copyWith({
    String? searchQuery,
    List<StockItem>? allItems,
    String? activeBranch,
    IncomingStockForm? incomingForm,
    String? justSubmittedMessage,
  }) {
    return StockLoaded(
      searchQuery: searchQuery ?? this.searchQuery,
      allItems: allItems ?? this.allItems,
      activeBranch: activeBranch ?? this.activeBranch,
      incomingForm: incomingForm ?? this.incomingForm,
      justSubmittedMessage: justSubmittedMessage,
    );
  }
}