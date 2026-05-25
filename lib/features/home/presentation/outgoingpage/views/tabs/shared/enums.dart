enum PaymentPlanType { interestFree, directEasyPayment }

enum VerificationStatus { idle, loading, verified, failed }

enum EasyPaymentStatus { idle, searching, found, notFound, submitting }

enum EasyPaymentFlow { none, continueFlow, endFlow }