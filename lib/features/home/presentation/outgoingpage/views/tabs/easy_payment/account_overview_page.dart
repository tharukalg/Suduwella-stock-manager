import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../blocs/outgoing_bloc.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/app_widgets.dart';
import '../shared/form_widgets.dart';

class AccountOverviewPage extends StatelessWidget {
  final EasyPaymentFormState form;
  const AccountOverviewPage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OutgoingBloc>();
    final bill = form.bill!;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Account Overview Card ──────────────────────────────
                SectionCard(
                  title: 'Account Overview',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'CURRENT BALANCE',
                                  style: TextStyle(
                                    fontFamily: AppTheme.primaryFont,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                    color: cs.onSurface.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      NumberFormat('#,###')
                                          .format(bill.currentBalance),
                                      style: TextStyle(
                                        fontFamily: AppTheme.secondaryFont,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w800,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'LKR',
                                      style: TextStyle(
                                        fontFamily: AppTheme.primaryFont,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: cs.onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'STATUS',
                                style: TextStyle(
                                  fontFamily: AppTheme.primaryFont,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.1,
                                  color: cs.onSurface.withOpacity(0.45),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: bill.isActive
                                      ? Colors.green.shade600
                                      : cs.error,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  bill.isActive ? 'Active' : 'Inactive',
                                  style: const TextStyle(
                                    fontFamily: AppTheme.primaryFont,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Divider(
                        height: 28,
                        thickness: 1,
                        color: cs.onSurface.withOpacity(0.08),
                      ),

                      _DetailRow(
                        label: 'Last Payment',
                        value:
                        '${NumberFormat('#,###').format(bill.lastPaymentAmount)} LKR',
                        trailing: DateFormat('dd MMM yyyy')
                            .format(bill.lastPaymentDate),
                      ),
                      const SizedBox(height: 10),
                      _DetailRow(
                        label: 'Total Paid',
                        value:
                        '${NumberFormat('#,###').format(bill.totalPaid)} LKR',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Continue / End buttons ─────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _BigActionButton(
                        icon: Icons.refresh_rounded,
                        label: 'CONTINUE',
                        onTap: () => bloc.add(EasyPaymentContinueEvent()),
                        isDestructive: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BigActionButton(
                        icon: Icons.block_rounded,
                        label: 'END',
                        onTap: () => _showEndDialog(context, bloc),
                        isDestructive: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Center(
                  child: TextButton.icon(
                    onPressed: () => bloc.add(EasyPaymentResetEvent()),
                    icon: Icon(Icons.arrow_back_rounded,
                        size: 16, color: cs.primary),
                    label: Text(
                      'Search another bill',
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 13,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// End dialog — lets the user choose what kind of ending this is:
  /// Fully Settled, Item Recovered, or cancel.
  void _showEndDialog(BuildContext context, OutgoingBloc bloc) {
    final cs = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.block_rounded, color: cs.error, size: 22),
            ),
            const SizedBox(height: 14),
            Text(
              'End Easy Payment',
              style: TextStyle(
                fontFamily: AppTheme.secondaryFont,
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select the reason for ending this easy payment plan:',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                color: cs.onSurface.withOpacity(0.65),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // ── Fully Settled option ───────────────────────────────────
            _EndOption(
              icon: Icons.check_circle_outline_rounded,
              label: 'Fully Settled',
              description: 'Customer has paid the full outstanding balance.',
              color: Colors.green.shade600,
              onTap: () {
                Navigator.pop(ctx);
                bloc.add(EasyPaymentFullySettledEvent());
              },
            ),

            const SizedBox(height: 10),

            // ── Item Recovered option ──────────────────────────────────
            _EndOption(
              icon: Icons.inventory_2_outlined,
              label: 'Item Recovered',
              description: 'Item has been physically recovered from the customer.',
              color: cs.error,
              onTap: () {
                Navigator.pop(ctx);
                bloc.add(EasyPaymentItemRecoveredEvent());
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(
              foregroundColor: cs.onSurface.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── End Option Row ────────────────────────────────────────────────────────────

class _EndOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _EndOption({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? color.withOpacity(0.08) : color.withOpacity(0.05),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: AppTheme.primaryFont,
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.55),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right_rounded,
                  color: color.withOpacity(0.6), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared private widgets ────────────────────────────────────────────────────

class _BigActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _BigActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isDestructive,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final color = isDestructive ? cs.error : AppTheme.brandPrimary;
    final bg = isDark ? color.withOpacity(0.12) : color.withOpacity(0.06);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String? trailing;

  const _DetailRow({
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          Text(
            trailing!,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              fontSize: 13,
              color: cs.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }
}