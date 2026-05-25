part of 'outgoing_bloc.dart';

enum PaymentPlanType { interestFree, directEasyPayment }

enum VerificationStatus { idle, loading, verified, failed }

// Status flow:
//   idle / searching / notFound  →  EasyPaymentSearchPage
//   found                        →  AccountOverviewPage
//   continued                    →  PlanAdjustmentPage  (Continue button)
//   submitting                   →  PlanAdjustmentPage  (End button)
enum EasyPaymentStatus { idle, searching, found, notFound, continued, submitting }

// ── Customer Entry ────────────────────────────────────────────────────────────

class CustomerEntry {
  final String id;
  final String name;
  final String phone;
  final String description;
  final VerificationStatus idStatus;
  final VerificationStatus phoneStatus;
  final List<String> photoPaths;
  final List<String> selfiePaths;

  const CustomerEntry({
    this.id = '',
    this.name = '',
    this.phone = '+94',
    this.description = '',
    this.idStatus = VerificationStatus.idle,
    this.phoneStatus = VerificationStatus.idle,
    this.photoPaths = const [],
    this.selfiePaths = const [],
  });

  CustomerEntry copyWith({
    String? id,
    String? name,
    String? phone,
    String? description,
    VerificationStatus? idStatus,
    VerificationStatus? phoneStatus,
    List<String>? photoPaths,
    List<String>? selfiePaths,
  }) {
    return CustomerEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      idStatus: idStatus ?? this.idStatus,
      phoneStatus: phoneStatus ?? this.phoneStatus,
      photoPaths: photoPaths ?? this.photoPaths,
      selfiePaths: selfiePaths ?? this.selfiePaths,
    );
  }
}

// ── New Sale State ────────────────────────────────────────────────────────────

class NewSaleFormState {
  final String modelNo;
  final String serialNo;
  final String productName;
  final String blNumber;
  final List<CustomerEntry> customers;
  final PaymentPlanType selectedPlan;
  final double totalAmount;
  final double downPayment;
  final int durationMonths;
  final bool isSubmitting;

  double get financedAmount => totalAmount - downPayment;
  double get monthlyInstallment =>
      durationMonths > 0 ? financedAmount / durationMonths : 0;

  const NewSaleFormState({
    this.modelNo = '',
    this.serialNo = '',
    this.productName = '',
    this.blNumber = 'KH-',
    this.customers = const [CustomerEntry()],
    this.selectedPlan = PaymentPlanType.interestFree,
    this.totalAmount = 0,
    this.downPayment = 0,
    this.durationMonths = 3,
    this.isSubmitting = false,
  });

  NewSaleFormState copyWith({
    String? modelNo,
    String? serialNo,
    String? productName,
    String? blNumber,
    List<CustomerEntry>? customers,
    PaymentPlanType? selectedPlan,
    double? totalAmount,
    double? downPayment,
    int? durationMonths,
    bool? isSubmitting,
  }) {
    return NewSaleFormState(
      modelNo: modelNo ?? this.modelNo,
      serialNo: serialNo ?? this.serialNo,
      productName: productName ?? this.productName,
      blNumber: blNumber ?? this.blNumber,
      customers: customers ?? this.customers,
      selectedPlan: selectedPlan ?? this.selectedPlan,
      totalAmount: totalAmount ?? this.totalAmount,
      downPayment: downPayment ?? this.downPayment,
      durationMonths: durationMonths ?? this.durationMonths,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// ── Easy Payment Bill Details ─────────────────────────────────────────────────

class EasyPaymentBillDetails {
  final String billNumber;
  final double currentBalance;
  final double lastPaymentAmount;
  final DateTime lastPaymentDate;
  final double totalPaid;
  final bool isActive;

  const EasyPaymentBillDetails({
    required this.billNumber,
    required this.currentBalance,
    required this.lastPaymentAmount,
    required this.lastPaymentDate,
    required this.totalPaid,
    required this.isActive,
  });
}

// ── Easy Payment State ────────────────────────────────────────────────────────

class EasyPaymentFormState {
  final String searchQuery;
  final EasyPaymentStatus status;
  final EasyPaymentBillDetails? bill;
  final int remainingMonths;
  final double monthlyInstallment;
  final String? errorMessage;

  const EasyPaymentFormState({
    this.searchQuery = '',
    this.status = EasyPaymentStatus.idle,
    this.bill,
    this.remainingMonths = 0,
    this.monthlyInstallment = 0,
    this.errorMessage,
  });

  EasyPaymentFormState copyWith({
    String? searchQuery,
    EasyPaymentStatus? status,
    EasyPaymentBillDetails? bill,
    int? remainingMonths,
    double? monthlyInstallment,
    String? errorMessage,
  }) {
    return EasyPaymentFormState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      bill: bill ?? this.bill,
      remainingMonths: remainingMonths ?? this.remainingMonths,
      monthlyInstallment: monthlyInstallment ?? this.monthlyInstallment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Drop-in additions for outgoing_state.dart
// Replace your existing B2BFormState class with this one.
// ─────────────────────────────────────────────────────────────────────────────

// ── B2B Cart Item ─────────────────────────────────────────────────────────────

class B2BCartItem {
  final String id; // unique key (e.g. uuid or timestamp string)
  final String modelNo;
  final String serialNo;
  final String notes;

  const B2BCartItem({
    required this.id,
    required this.modelNo,
    required this.serialNo,
    this.notes = '',
  });
}

// ── B2B State ─────────────────────────────────────────────────────────────────

class B2BFormState {
  final String destinationBranch; // e.g. 'KH', 'KL', …
  final String modelNo;           // current input field
  final String serialNo;          // current input field
  final String notes;             // current input field
  final List<B2BCartItem> items;  // added items (cart)
  final bool isSubmitting;

  const B2BFormState({
    this.destinationBranch = '',
    this.modelNo = '',
    this.serialNo = '',
    this.notes = '',
    this.items = const [],
    this.isSubmitting = false,
  });

  B2BFormState copyWith({
    String? destinationBranch,
    String? modelNo,
    String? serialNo,
    String? notes,
    List<B2BCartItem>? items,
    bool? isSubmitting,
  }) {
    return B2BFormState(
      destinationBranch: destinationBranch ?? this.destinationBranch,
      modelNo: modelNo ?? this.modelNo,
      serialNo: serialNo ?? this.serialNo,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
// ── Root State ────────────────────────────────────────────────────────────────

@immutable
sealed class OutgoingState {}

final class OutgoingInitial extends OutgoingState {
  OutgoingInitial();
}

final class OutgoingLoaded extends OutgoingState {
  final NewSaleFormState newSale;
  final EasyPaymentFormState easyPayment;
  final B2BFormState b2b;

  OutgoingLoaded({
    this.newSale = const NewSaleFormState(),
    this.easyPayment = const EasyPaymentFormState(),
    this.b2b = const B2BFormState(),
  });

  OutgoingLoaded copyWith({
    NewSaleFormState? newSale,
    EasyPaymentFormState? easyPayment,
    B2BFormState? b2b,
  }) {
    return OutgoingLoaded(
      newSale: newSale ?? this.newSale,
      easyPayment: easyPayment ?? this.easyPayment,
      b2b: b2b ?? this.b2b,
    );
  }
}

final class OutgoingSubmitSuccess extends OutgoingState {
  final String tabLabel;
  OutgoingSubmitSuccess(this.tabLabel);
}

final class OutgoingError extends OutgoingState {
  final String message;
  OutgoingError(this.message);
}