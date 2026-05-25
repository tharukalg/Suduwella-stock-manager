import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/outgoing_bloc.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/app_widgets.dart';
import '../shared/form_widgets.dart';

class EasyPaymentSearchPage extends StatefulWidget {
  final EasyPaymentFormState form;
  const EasyPaymentSearchPage({super.key, required this.form});

  @override
  State<EasyPaymentSearchPage> createState() => _EasyPaymentSearchPageState();
}

class _EasyPaymentSearchPageState extends State<EasyPaymentSearchPage> {
  late final TextEditingController _searchCtrl;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController(text: widget.form.searchQuery);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final form = widget.form;
    final cs = Theme.of(context).colorScheme;
    final isSearching = form.status == EasyPaymentStatus.searching;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionCard(
              title: 'Search a bill Number',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _searchCtrl,
                          hint: 'Search Bill Number',
                          suffixIcon: Icons.barcode_reader,
                          textInputAction: TextInputAction.search,
                          onChanged: (v) => bloc.add(
                              EasyPaymentSearchQueryChangedEvent(v)),
                          onSubmitted: (_) {
                            if (!isSearching) {
                              bloc.add(EasyPaymentSearchEvent());
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: isSearching
                              ? null
                              : () => bloc.add(EasyPaymentSearchEvent()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.brandPrimary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                            AppTheme.brandPrimary.withOpacity(0.5),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: isSearching
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Text(
                            'Search',
                            style: TextStyle(
                              fontFamily: AppTheme.primaryFont,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Not found message
                  if (form.status == EasyPaymentStatus.notFound) ...[
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .error
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search_off_rounded,
                              color: cs.error, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'No bill found for "${form.searchQuery}"',
                            style: TextStyle(
                              fontFamily: AppTheme.primaryFont,
                              fontSize: 13,
                              color: cs.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Tip
            const SizedBox(height: 16),
            _SearchTip(),
          ],
        ),
      ),
    );
  }
}

class _SearchTip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? cs.primary.withOpacity(0.1)
            : cs.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.primary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: cs.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Enter the bill number or scan the barcode to look up an existing easy payment account.',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                color: cs.primary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}