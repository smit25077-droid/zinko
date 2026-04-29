import 'dart:ui' show ImageFilter;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:zinko_app/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:zinko_app/features/wallet/domain/entities/wallet_transaction.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_common_dialog.dart';
import 'package:zinko_app/core/di/service_locator.dart';
import 'package:zinko_app/utils/common_util.dart';

class WalletScreen extends StatelessWidget {
  static const String routeName = '/wallet';

  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>(),
      child: Scaffold(
        appBar: const ZinkoAppBar(
          title: 'My Wallet',
        ),
        body: ZinkoBackground(
          child: BlocListener<WalletBloc, WalletState>(
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
              buildWhen: (p, c) => c is WalletLoading || c is WalletLoaded || c is WalletError,
              builder: (context, state) {
                if (state is WalletInitial) {
                  context.read<WalletBloc>().add(FetchWalletDataEvent());
                  return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
                }
                if (state is WalletLoading) {
                  return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
                }
                if (state is WalletError) {
                  // Return an empty state or show standard error UI snippet. Usually we'd show a retry button.
                }
                if (state is WalletLoaded) {
                  final balance = state.balance;
                  final transactions = state.transactions;
                  return ZinkoScrollBody(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonUtil.vGap20,
                        _buildWalletCard(context, balance.balance),
                        CommonUtil.vGap24,
                        _buildActionButton(
                          context,
                          Icons.add_circle_outline_rounded,
                          'ADD MONEY',
                          () => _showAddMoneyDialog(context),
                          highlight: true,
                        ).animate(delay: 200.ms).fadeIn(duration: 250.ms).slideX(begin: 0.05, end: 0),
                        CommonUtil.vGap32,
                        Text(
                          'RECENT TRANSACTIONS',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                               color: OptimizedColors.white50,
                              letterSpacing: 1.5),
                        ).animate(delay: 250.ms).fadeIn(duration: 250.ms),
                        CommonUtil.vGap16,
                        ...transactions.asMap().entries.map((entry) {
                          final index = entry.key;
                          final tx = entry.value;
                          return _buildTransactionItem(context, tx)
                              .animate()
                              .fadeIn(delay: (index * 30 + 150).ms, duration: 250.ms);
                        }),
                        CommonUtil.vGap120,
                      ],
                    ),
                  );
                }
                return Center(child: Text('Data error', style: TextStyle(color: GlassTheme.textColor(context))));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, double balance) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: CommonUtil.bRadius28,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        colors: [
          OptimizedColors.white16,
          OptimizedColors.white04,
        ],
      ),
      border: Border.all(color: OptimizedColors.white16, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: OptimizedColors.black20,
          blurRadius: 30,
          offset: const Offset(0, 15),
        )
      ],
      ),
      child: ClipRRect(
        borderRadius: CommonUtil.bRadius28,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: CommonUtil.pAll20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ZINKO',
                            style: TextStyle(
                                color: OptimizedColors.white90,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5)),
                        CommonUtil.vGap4,
                        Text('VIRTUAL CARD',
                            style: TextStyle(
                                color: OptimizedColors.white40,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2)),
                      ],
                    ),
                    Icon(Icons.nfc_rounded, color: OptimizedColors.white30, size: 28),
                  ],
                ),
                CommonUtil.vGap25,
                Text('AVAILABLE BALANCE',
                    style: TextStyle(
                        color: OptimizedColors.white40,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
                // const SizedBox(height: 8),
                Text(
                  '£${balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -1.0),
                ),
                CommonUtil.vGap25,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('****  ****  ****  8888',
                        style: TextStyle(
                            color: OptimizedColors.white70,
                            fontSize: 14,
                            letterSpacing: 2.0,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('VALID THRU',
                            style: TextStyle(
                                color: OptimizedColors.white30, fontSize: 8, fontWeight: FontWeight.w800)),
                        Text('12/28',
                            style: TextStyle(
                                color: OptimizedColors.white80, fontSize: 12, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().scale(duration: 300.ms, curve: Curves.easeOut).fadeIn();
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool highlight = false}) {
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: highlight ? Colors.white : OptimizedColors.white05,
            borderRadius: CommonUtil.bRadius18,
            border: Border.all(color: highlight ? Colors.white : OptimizedColors.white16, width: 1.5),
            boxShadow: highlight
                ? [
                    BoxShadow(
                      color: OptimizedColors.white20,
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: highlight ? Colors.black : Colors.white),
              CommonUtil.hGap12,
              Text(
                label,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: highlight ? Colors.black : Colors.white,
                    letterSpacing: 1.5),
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
      child: ZinkoCommonCard(
        margin: CommonUtil.pBottom12,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isCredit ? OptimizedColors.success20 : OptimizedColors.error08,
                borderRadius: CommonUtil.bRadius14,
                border: Border.all(
                    color: isCredit ? OptimizedColors.success20 : OptimizedColors.error20),
              ),
              child: Icon(
                isCredit ? Icons.add_rounded : Icons.remove_rounded,
                color: isCredit ? Colors.greenAccent : Colors.redAccent,
                size: 22,
              ),
            ),
            CommonUtil.hGap16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DateFormat('dd/MM/yyyy HH:mm').format(tx.transactionDate),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                  CommonUtil.vGap4,
                  Text(tx.eventMode,
                      style: const TextStyle(
                          fontSize: 10,
                          color: OptimizedColors.white40,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5)),
                  if (tx.remark != null && tx.remark!.isNotEmpty) ...{
                    CommonUtil.vGap4,
                    Text(tx.remark ?? 'NA',
                        style: const TextStyle(
                            fontSize: 10,
                            color: OptimizedColors.white40,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5)),
                  }
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isCredit ? '+' : '-'} £${tx.amount.toInt()}',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w900, color: isCredit ? Colors.greenAccent : Colors.white),
                ),
                Text(
                  'COMPLETED',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w900,
                    color: OptimizedColors.white20,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final controller = TextEditingController();
    ZinkoCommonDialog.show(
      context: context,
      title: 'ADD MONEY',
      actionLabel: 'CONFIRM',
      customContent: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        style: TextStyle(color: GlassTheme.textColor(context), fontWeight: FontWeight.w800, fontSize: 18),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: 'AMOUNT',
          hintStyle: TextStyle(color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.3)),
          prefixText: '£ ',
          prefixStyle: TextStyle(color: GlassTheme.textColor(context), fontWeight: FontWeight.w800),
          filled: true,
          fillColor: GlassTheme.textColor(context).withValues(alpha: 0.05),
          border: OutlineInputBorder(borderRadius: CommonUtil.bRadius16, borderSide: BorderSide.none),
        ),
      ),
      onAction: () {
        final amount = double.tryParse(controller.text) ?? 0;
        if (amount > 0) {
          context.read<UserBloc>().add(AddMoneyEvent(amount));
        }
        Navigator.pop(context);
      },
    );
  }

  void _showStatusPopup(BuildContext context, String message, {bool isSuccess = true}) {
    ZinkoCommonDialog.show(
      context: context,
      title: isSuccess ? 'SUCCESS' : 'ERROR',
      message: message,
      icon: isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
      iconColor: isSuccess ? AppColors.success : AppColors.error,
      actionLabel: 'OK',
      actionColor: isSuccess ? AppColors.success : AppColors.error,
      onAction: () => Navigator.pop(context),
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
