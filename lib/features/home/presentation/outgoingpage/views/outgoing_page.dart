import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/locator.dart';
import '../blocs/outgoing_bloc.dart';
import '../../../../../core/theme/app_theme.dart';
import 'tabs/new_sale_tab.dart';
import 'tabs/easy_payment_tab.dart';
import 'tabs/b2b_tab.dart';

class OutgoingPage extends StatelessWidget {
  const OutgoingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OutgoingBloc>()..add(OutgoingInitEvent()),
      child: const _OutgoingView(),
    );
  }
}

class _OutgoingView extends StatefulWidget {
  const _OutgoingView();

  @override
  State<_OutgoingView> createState() => _OutgoingViewState();
}

class _OutgoingViewState extends State<_OutgoingView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<OutgoingBloc, OutgoingState>(
      listener: (context, state) {
        if (state is OutgoingSubmitSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.tabLabel} submitted successfully!'),
              backgroundColor: cs.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Disable the default centered title
          centerTitle: false,
          automaticallyImplyLeading: true,
          // Use toolbarHeight to give room for title + subtitle
          toolbarHeight: 64,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Tab-aware title that updates as user switches tabs
              AnimatedBuilder(
                animation: _tabController,
                builder: (context, _) {
                  const titles = ['New Sale', 'Easy Payment', 'B2B'];
                  const subtitles = [
                    'OUTGOING STOCK ENTRY',
                    'EASY PAYMENT ENTRY',
                    'B2B ORDER ENTRY',
                  ];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        titles[_tabController.index],
                        style: const TextStyle(
                          fontFamily: AppTheme.secondaryFont,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitles[_tabController.index],
                        style: TextStyle(
                          fontFamily: AppTheme.primaryFont,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          letterSpacing: 1.2,
                          color: cs.onSurface.withOpacity(0.45),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'New Sale'),
              Tab(text: 'Easy Payment'),
              Tab(text: 'B2B'),
            ],
            labelStyle: const TextStyle(
              fontFamily: AppTheme.secondaryFont,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            unselectedLabelStyle: const TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
            indicatorWeight: 3,
            dividerColor: Colors.transparent,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            NewSaleTab(),
            EasyPaymentTab(),
            B2BTab(),
          ],
        ),
      ),
    );
  }
}