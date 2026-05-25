import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../core/di/locator.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/router/app_router.dart';
import '../blocs/homepage_bloc.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomepageBloc>()..add(HomepageInitializeEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomepageBloc, HomepageState>(
          builder: (context, state) {
            return switch (state) {
              HomepageLoaded() => _LoadedBody(state: state),
              HomepageError()  => _ErrorBody(message: state.message),
              _                => const _LoadingBody(),
            };
          },
        ),
      ),
    );
  }
}

// ── Loading ───────────────────────────────────────────────────────────────────

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: AppTheme.brandPrimary),
    );
  }
}

// ── Error ─────────────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  final String message;
  const _ErrorBody({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48, color: cs.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: cs.error, fontFamily: AppTheme.primaryFont),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loaded ────────────────────────────────────────────────────────────────────

class _LoadedBody extends StatelessWidget {
  final HomepageLoaded state;
  const _LoadedBody({required this.state});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final hPad = width > 600 ? 24.0 : 16.0;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 24),
              _Header(state: state),
              const SizedBox(height: 24),
              const _QuickActionsCard(),
              const SizedBox(height: 16),
              _CrisAlertsCard(count: state.crisAlertCount),
              const SizedBox(height: 16),
              _SyncStatusRow(lastSyncedAt: state.lastSyncedAt),
              const SizedBox(height: 32),
            ]),
          ),
        ),
      ],
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final HomepageLoaded state;
  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Branch: ${state.branchName}',
          style: textTheme.titleLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(state.currentTime),
          style: TextStyle(
            fontFamily: AppTheme.primaryFont,
            fontSize: 13,
            color: cs.onSurface.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 2),
        BlocSelector<HomepageBloc, HomepageState, DateTime?>(
          selector: (s) => s is HomepageLoaded ? s.currentTime : null,
          builder: (context, time) {
            if (time == null) return const SizedBox.shrink();
            return Text(
              DateFormat('hh:mm a').format(time),
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 13,
                color: cs.onSurface.withOpacity(0.55),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final cardBg = isDark
        ? cs.surfaceContainerHigh
        : AppTheme.brandPrimary.withOpacity(0.06);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: cs.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontFamily: AppTheme.secondaryFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = (constraints.maxWidth - 12) / 2;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _ActionTile(
                    label: 'Outgoing\nStock',
                    icon: Icons.trending_up_rounded,
                    highlighted: true,
                    width: tileWidth,
                    onTap: () => context.go(Routes.outgoing),
                  ),
                  _ActionTile(
                    label: 'Incoming\nStock',
                    icon: Icons.qr_code_scanner_rounded,
                    highlighted: true,
                    width: tileWidth,
                    onTap: () => context.go(Routes.stock),
                  ),
                  _ActionTile(
                    label: 'Available\nProducts',
                    icon: Icons.inventory_2_outlined,
                    highlighted: false,
                    width: tileWidth,
                    onTap: () => context.go(Routes.stock),
                  ),
                  _ActionTile(
                    label: 'CRIS\nPanel',
                    icon: Icons.credit_card_outlined,
                    highlighted: false,
                    width: tileWidth,
                    onTap: () => context.go(Routes.cris),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool highlighted;
  final double width;
  final VoidCallback onTap;

  const _ActionTile({
    required this.label,
    required this.icon,
    required this.highlighted,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final Color bg;
    final Color iconColor;
    final Color labelColor;

    if (highlighted) {
      bg = AppTheme.brandPrimary;
      iconColor = Colors.white;
      labelColor = Colors.white;
    } else {
      bg = isDark ? cs.surfaceContainerHighest : Colors.white;
      iconColor = cs.primary;
      labelColor = cs.onSurface;
    }

    return SizedBox(
      width: width,
      height: 110,
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.1),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 26),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── CRIS Alerts ───────────────────────────────────────────────────────────────

class _CrisAlertsCard extends StatelessWidget {
  final int count;
  const _CrisAlertsCard({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    final cardBg = isDark
        ? cs.surfaceContainerHigh
        : AppTheme.brandPrimary.withOpacity(0.06);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: cs.error, width: 4)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: cs.error, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    'Total CRIS alerts',
                    style: TextStyle(
                      fontFamily: AppTheme.secondaryFont,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go(Routes.cris),
                style: TextButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: cs.primary,
                ),
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (count == 0)
            SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'No active alerts',
                  style: TextStyle(
                    fontFamily: AppTheme.primaryFont,
                    fontSize: 14,
                    color: cs.onSurface.withOpacity(0.4),
                  ),
                ),
              ),
            )
          else
            Text(
              '$count',
              style: TextStyle(
                fontFamily: AppTheme.secondaryFont,
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: cs.error,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Sync Status ───────────────────────────────────────────────────────────────

class _SyncStatusRow extends StatelessWidget {
  final DateTime? lastSyncedAt;
  const _SyncStatusRow({this.lastSyncedAt});

  String get _label {
    if (lastSyncedAt == null) return 'Never synced';
    final diff = DateTime.now().difference(lastSyncedAt!);
    if (diff.inSeconds < 60) return 'Last synced just now';
    if (diff.inMinutes < 60) return 'Last synced ${diff.inMinutes} mins ago';
    return 'Last synced ${diff.inHours}h ago';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? cs.surfaceContainerHigh
                : AppTheme.brandPrimary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.sync_rounded, color: cs.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All records up to date',
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _label,
              style: TextStyle(
                fontFamily: AppTheme.primaryFont,
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
}