part of 'outgoing_bloc.dart';

@immutable
sealed class OutgoingEvent {}

class OutgoingInitEvent extends OutgoingEvent {}

// Product
class ModelNoChangedEvent extends OutgoingEvent {
  final String value;
  ModelNoChangedEvent(this.value);
}

class SerialNoChangedEvent extends OutgoingEvent {
  final String value;
  SerialNoChangedEvent(this.value);
}

class BLNumberChangedEvent extends OutgoingEvent {
  final String value;
  BLNumberChangedEvent(this.value);
}

// Customer
class CustomerIdChangedEvent extends OutgoingEvent {
  final int customerIndex;
  final String value;
  CustomerIdChangedEvent(this.customerIndex, this.value);
}

class CustomerNameChangedEvent extends OutgoingEvent {
  final int customerIndex;
  final String value;
  CustomerNameChangedEvent(this.customerIndex, this.value);
}

class CustomerPhoneChangedEvent extends OutgoingEvent {
  final int customerIndex;
  final String value;
  CustomerPhoneChangedEvent(this.customerIndex, this.value);
}

class CustomerDescriptionChangedEvent extends OutgoingEvent {
  final int customerIndex;
  final String value;
  CustomerDescriptionChangedEvent(this.customerIndex, this.value);
}

class LookupCustomerByNicEvent extends OutgoingEvent {
  final int customerIndex;
  LookupCustomerByNicEvent(this.customerIndex);
}

class VerifyCustomerIdEvent extends OutgoingEvent {
  final int customerIndex;
  VerifyCustomerIdEvent(this.customerIndex);
}

class VerifyCustomerPhoneEvent extends OutgoingEvent {
  final int customerIndex;
  VerifyCustomerPhoneEvent(this.customerIndex);
}

class AddCustomerEvent extends OutgoingEvent {}

class RemoveCustomerEvent extends OutgoingEvent {
  final int index;
  RemoveCustomerEvent(this.index);
}

// Customer ID Photos
class AddCustomerPhotoEvent extends OutgoingEvent {
  final int customerIndex;
  final String imagePath;
  AddCustomerPhotoEvent(this.customerIndex, this.imagePath);
}

class RemoveCustomerPhotoEvent extends OutgoingEvent {
  final int customerIndex;
  final int photoIndex;
  RemoveCustomerPhotoEvent(this.customerIndex, this.photoIndex);
}

// Customer Selfie Photos
class AddCustomerSelfieEvent extends OutgoingEvent {
  final int customerIndex;
  final String imagePath;
  AddCustomerSelfieEvent(this.customerIndex, this.imagePath);
}

class RemoveCustomerSelfieEvent extends OutgoingEvent {
  final int customerIndex;
  final int photoIndex;
  RemoveCustomerSelfieEvent(this.customerIndex, this.photoIndex);
}

// Payment
class PaymentPlanChangedEvent extends OutgoingEvent {
  final PaymentPlanType plan;
  PaymentPlanChangedEvent(this.plan);
}

class DownPaymentChangedEvent extends OutgoingEvent {
  final String value;
  DownPaymentChangedEvent(this.value);
}

class DurationChangedEvent extends OutgoingEvent {
  final int months;
  DurationChangedEvent(this.months);
}

class SubmitOutgoingEvent extends OutgoingEvent {}

// Easy Payment
class EasyPaymentSearchQueryChangedEvent extends OutgoingEvent {
  final String value;
  EasyPaymentSearchQueryChangedEvent(this.value);
}

class EasyPaymentSearchEvent extends OutgoingEvent {}

class EasyPaymentContinueEvent extends OutgoingEvent {}

class EasyPaymentEndEvent extends OutgoingEvent {}

class EasyPaymentRemainingMonthsChangedEvent extends OutgoingEvent {
  final int months;
  EasyPaymentRemainingMonthsChangedEvent(this.months);
}

class EasyPaymentInstallmentChangedEvent extends OutgoingEvent {
  final double amount;
  EasyPaymentInstallmentChangedEvent(this.amount);
}

class EasyPaymentUpdatePlanEvent extends OutgoingEvent {}

class EasyPaymentFullySettledEvent extends OutgoingEvent {}

class EasyPaymentItemRecoveredEvent extends OutgoingEvent {}

class EasyPaymentResetEvent extends OutgoingEvent {}

// ─────────────────────────────────────────────────────────────────────────────
// Drop-in additions for outgoing_event.dart
// Replace the old B2B event block with these.
// ─────────────────────────────────────────────────────────────────────────────

// B2B
class B2BDestinationBranchChangedEvent extends OutgoingEvent {
  final String branch;
  B2BDestinationBranchChangedEvent(this.branch);
}

class B2BModelNoChangedEvent extends OutgoingEvent {
  final String value;
  B2BModelNoChangedEvent(this.value);
}

class B2BSerialNoChangedEvent extends OutgoingEvent {
  final String value;
  B2BSerialNoChangedEvent(this.value);
}

class B2BNotesChangedEvent extends OutgoingEvent {
  final String value;
  B2BNotesChangedEvent(this.value);
}

class B2BAddItemEvent extends OutgoingEvent {}

class B2BRemoveItemEvent extends OutgoingEvent {
  final String itemId;
  B2BRemoveItemEvent(this.itemId);
}

class SubmitB2BEvent extends OutgoingEvent {}