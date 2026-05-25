import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suduwella_stock_manager/features/home/presentation/outgoingpage/views/tabs/shared/customer_payment_page.dart';
import 'package:suduwella_stock_manager/features/home/presentation/outgoingpage/views/tabs/shared/product_page.dart';
import '../../blocs/outgoing_bloc.dart';
class NewSaleTab extends StatefulWidget {
  const NewSaleTab({super.key});

  @override
  State<NewSaleTab> createState() => _NewSaleTabState();
}

class _NewSaleTabState extends State<NewSaleTab> {
  int _page = 0;

  void _goToPage2() => setState(() => _page = 1);
  void _goToPage1() => setState(() => _page = 0);

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OutgoingBloc, OutgoingState, NewSaleFormState?>(
      selector: (state) => state is OutgoingLoaded ? state.newSale : null,
      builder: (context, form) {
        if (form == null) return const SizedBox.shrink();
        return _page == 0
            ? ProductPage(
          key: const ValueKey('product'),
          form: form,
          onNext: _goToPage2,
        )
            : CustomerPaymentPage(
          key: const ValueKey('customer'),
          form: form,
          onBack: _goToPage1,
        );
      },
    );
  }
}