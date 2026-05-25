import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/outgoing_bloc.dart';
import 'easy_payment/search_page.dart';
import 'easy_payment/account_overview_page.dart';
import 'easy_payment/plan_adjustment_page.dart';

class EasyPaymentTab extends StatelessWidget {
  const EasyPaymentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OutgoingBloc, OutgoingState, EasyPaymentFormState?>(
      selector: (s) => s is OutgoingLoaded ? s.easyPayment : null,
      builder: (context, form) {
        if (form == null) return const SizedBox.shrink();

        return switch (form.status) {
        // Bill found → account overview with Continue / End buttons
          EasyPaymentStatus.found => AccountOverviewPage(form: form),
        // Continue pressed → plan adjustment page
          EasyPaymentStatus.continued => PlanAdjustmentPage(form: form),
        // End confirmed (Fully Settled / Item Recovered chosen) → plan adjustment page
          EasyPaymentStatus.submitting => PlanAdjustmentPage(form: form),
        // idle / searching / notFound → search page
          _ => EasyPaymentSearchPage(form: form),
        };
      },
    );
  }
}