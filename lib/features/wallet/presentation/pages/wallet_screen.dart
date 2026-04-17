import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import '../bloc/wallet_bloc.dart';
import '../bloc/wallet_event.dart';
import '../bloc/wallet_state.dart';
import '../../domain/entities/wallet_transaction.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/optimized_colors.dart';
import '../../../../widgets/zinko_background.dart';
import '../../../../widgets/zinko_app_bar.dart';
import '../../../../core/di/service_locator.dart';

class WalletScreen extends StatelessWidget {
  static const String routeName = '/wallet';
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>(),
      child: ZinkoBackground(
        child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.transparent,
        appBar: const ZinkoAppBar(
          title: 'My Wallet',
        ),
        body: BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletLoaded) {
              // We could check for a flag in state, but assuming a load after redeem is success
              // _showStatusPopup(context, 'Success!', isSuccess: true);
            }
            if (state is WalletError) {
              _showStatusPopup(context, state.message, isSuccess: false);
            }
          },
          child: BlocBuilder<WalletBloc, WalletState>(
            builder: (context, state) {
              if (state is WalletInitial) {
                context.read<WalletBloc>().add(FetchWalletDataEvent());
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }
              if (state is WalletLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }
              if (state is WalletError) {
                // Return an empty state or show standard error UI snippet. Usually we'd show a retry button.
              }
              if (state is WalletLoaded) {
                final balance = state.balance;
                final transactions = state.transactions;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            _buildWalletCard(context, balance.balance),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    context,
                                    Icons.add_circle_outline_rounded,
                                    'ADD MONEY',
                                    () => _showAddMoneyDialog(context),
                                    highlight: true,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    context,
                                    Icons.card_giftcard_rounded,
                                    'REDEEM',
                                    () => _showRedeemDialog(context),
                                  ),
                                ),
                              ],
                            )
                                .animate(delay: 400.ms)
                                .fadeIn()
                                ,
                            const SizedBox(height: 32),
                            Text(
                              'RECENT TRANSACTIONS',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  color: GlassTheme.secondaryTextColor(context)
                                      .withValues(alpha: 0.5),
                                  letterSpacing: 1.5),
                            ).animate(delay: 500.ms).fadeIn(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final tx = transactions[index];
                            return _buildTransactionItem(context, tx)
                                .animate()
                                .fadeIn(delay: (index * 100 + 600).ms)
                                ;
                          },
                          childCount: transactions.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              }
              return Center(
                  child: Text('Data error',
                      style: TextStyle(color: GlassTheme.textColor(context))));
            },
          ),
        ),
      ),
      ),
    );
  }


  Widget _buildWalletCard(BuildContext context, double balance) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: OptimizedColors.white12,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
            boxShadow: [GlassTheme.glassShadow(context)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('ZINKO UK',
                      style: TextStyle(
                          color: GlassTheme.textColor(context),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5)),
                  Icon(Icons.contactless_rounded,
                      color: GlassTheme.secondaryTextColor(context)
                          .withValues(alpha: 0.4),
                      size: 24),
                ],
              ),
              const SizedBox(height: 24),
              Text('AVAILABLE BALANCE',
                  style: TextStyle(
                      color: GlassTheme.secondaryTextColor(context)
                          .withValues(alpha: 0.5),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text(
                '£${balance.toStringAsFixed(2)}',
                style: TextStyle(
                    color: GlassTheme.textColor(context),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('****  ****  ****  8888',
                      style: TextStyle(
                          color: GlassTheme.secondaryTextColor(context)
                              .withValues(alpha: 0.6),
                          fontSize: 13,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600)),
                  Text('EXP 12/28',
                      style: TextStyle(
                          color: GlassTheme.secondaryTextColor(context)
                              .withValues(alpha: 0.4),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutCubic).fadeIn();
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool highlight = false}) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: highlight ? Colors.white : OptimizedColors.white12,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color:
                    highlight ? Colors.white : GlassTheme.glassBorder(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color:
                      highlight ? Colors.black : GlassTheme.textColor(context)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: highlight
                        ? Colors.black
                        : GlassTheme.textColor(context),
                    letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, WalletTransaction tx) {
    final isCredit = tx.isCredit;
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: OptimizedColors.white12,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GlassTheme.glassBorder(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCredit
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.red.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCredit ? Icons.add_rounded : Icons.remove_rounded,
                color: isCredit ? Colors.greenAccent : Colors.redAccent,
                size: 16,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.remark ?? tx.transactionType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: GlassTheme.textColor(context))),
                  const SizedBox(height: 2),
                  Text(tx.dateStr,
                      style: TextStyle(
                          fontSize: 11,
                          color: GlassTheme.secondaryTextColor(context)
                              .withValues(alpha: 0.5),
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Text(
              '${isCredit ? '+' : '-'} £${tx.amount.toInt()}',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: isCredit
                      ? Colors.greenAccent
                      : GlassTheme.textColor(context)),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    _showGlassDialog(
      context: context,
      title: 'ADD MONEY',
      hint: 'AMOUNT',
      prefix: '£ ',
      keyboard: TextInputType.number,
      onConfirm: (val) {
        final amount = double.tryParse(val) ?? 0;
        if (amount > 0) {
          context.read<UserBloc>().add(AddMoneyEvent(amount));
        }
      },
    );
  }

  void _showRedeemDialog(BuildContext context) {
    _showGlassDialog(
      context: context,
      title: 'REDEEM CODE',
      hint: 'CODE',
      onConfirm: (val) {
        if (val.isNotEmpty) {
          context.read<UserBloc>().add(RedeemReferralEvent(val));
        }
      },
    );
  }

  void _showStatusPopup(BuildContext context, String message,
      {bool isSuccess = true}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.2),
      builder: (ctx) {
        Future.delayed(const Duration(seconds: 1), () {
          if (ctx.mounted) Navigator.pop(ctx);
        });
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1220),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isSuccess
                      ? Colors.greenAccent.withValues(alpha: 0.3)
                      : Colors.redAccent.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                    color: (isSuccess ? Colors.greenAccent : Colors.redAccent)
                        .withValues(alpha: 0.1),
                    blurRadius: 40)
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    isSuccess
                        ? Icons.check_circle_outline_rounded
                        : Icons.error_outline_rounded,
                    color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                    size: 24),
                const SizedBox(width: 12),
                Text(
                  message.toUpperCase(),
                  style: TextStyle(
                    color: GlassTheme.textColor(context),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1.0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn();
      },
    );
  }

  void _showGlassDialog({
    required BuildContext context,
    required String title,
    required String hint,
    String? prefix,
    TextInputType? keyboard,
    required Function(String) onConfirm,
  }) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1220),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                    style: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1.0)),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  keyboardType: keyboard,
                  autofocus: true,
                  style: TextStyle(
                      color: GlassTheme.textColor(context),
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                        color: GlassTheme.secondaryTextColor(context)
                            .withValues(alpha: 0.3)),
                    prefixText: prefix,
                    prefixStyle: TextStyle(
                        color: GlassTheme.textColor(context),
                        fontWeight: FontWeight.w800),
                    filled: true,
                    fillColor: GlassTheme.textColor(context).withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('CANCEL',
                            style: TextStyle(
                                color: GlassTheme.secondaryTextColor(context)
                                    .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onConfirm(controller.text);
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text('CONFIRM',
                            style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// NOTE: AddMoneyEvent & RedeemReferralEvent have to be implemented in WalletBloc if needed.
// Temporarily leaving them pointing nowhere if we removed UserBloc from scope, or you might need to leave UserBloc provided above it.
}

// class _GlassHeaderButton extends StatelessWidget {
//   final IconData icon;
//   final VoidCallback onTap;
//   const _GlassHeaderButton({required this.icon, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//           child: Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: GlassTheme.glassColor(context),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: GlassTheme.glassBorder(context)),
//             ),
//             child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }

