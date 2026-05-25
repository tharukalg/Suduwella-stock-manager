part of 'stock_bloc.dart';

@immutable
sealed class StockEvent {}

// ── Init ──────────────────────────────────────────────────────────────────────
class StockInitialLoadEvent extends StockEvent {}

// ── Search ────────────────────────────────────────────────────────────────────
class StockSearchQueryChangedEvent extends StockEvent {
  final String query;
  StockSearchQueryChangedEvent(this.query);
}

// ── Incoming Stock › Tab ──────────────────────────────────────────────────────
class IncomingTabChangedEvent extends StockEvent {
  final IncomingStockTab tab;
  IncomingTabChangedEvent(this.tab);
}

// ── Incoming Stock › New Item ─────────────────────────────────────────────────
class NewItemSerialNoChangedEvent extends StockEvent {
  final String value;
  NewItemSerialNoChangedEvent(this.value);
}

class NewItemModelNoChangedEvent extends StockEvent {
  final String value;
  NewItemModelNoChangedEvent(this.value);
}

class NewItemProductNameChangedEvent extends StockEvent {
  final String value;
  NewItemProductNameChangedEvent(this.value);
}

class NewItemPriceChangedEvent extends StockEvent {
  final String value;
  NewItemPriceChangedEvent(this.value);
}

class SubmitNewItemEvent extends StockEvent {}

// ── Incoming Stock › Recovered Item ──────────────────────────────────────────
class RecItemSerialNoChangedEvent extends StockEvent {
  final String value;
  RecItemSerialNoChangedEvent(this.value);
}

class RecItemModelNoChangedEvent extends StockEvent {
  final String value;
  RecItemModelNoChangedEvent(this.value);
}

class RecItemProductNameChangedEvent extends StockEvent {
  final String value;
  RecItemProductNameChangedEvent(this.value);
}

class RecItemPriceChangedEvent extends StockEvent {
  final String value;
  RecItemPriceChangedEvent(this.value);
}

class SubmitRecoveredItemEvent extends StockEvent {}