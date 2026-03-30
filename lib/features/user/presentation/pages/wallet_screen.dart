import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/zinko_background.dart';

class WalletScreen extends StatelessWidget {
  static const String routeName = '/wallet';
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.transparent,
      body: ZinkoBackground(
        child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
              }
              if (state is UserError) {
                return Center(child: Text(state.message, style: TextStyle(color: GlassTheme.textColor(context))));
              }
              if (state is UserLoaded) {
                final user = state.user;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(context),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            _buildWalletCard(context, user.balance),
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
                            ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
                            const SizedBox(height: 32),
                            
                            Text(
                              'RECENT TRANSACTIONS',
                              style: TextStyle(
                                fontSize: 10, 
                                fontWeight: FontWeight.w900, 
                                color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), 
                                letterSpacing: 1.5
                              ),
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
                            final tx = user.transactions[index];
                            return _buildTransactionItem(context, tx)
                                .animate()
                                .fadeIn(delay: (index * 100 + 600).ms)
                                .slideX(begin: 0.05);
                          },
                          childCount: user.transactions.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                );
              }
              return Center(child: Text('Data error', style: TextStyle(color: GlassTheme.textColor(context))));
            },
          ),
        ),
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      floating: true,
      pinned: true,
      expandedHeight: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _GlassHeaderButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        'MY WALLET',
        style: TextStyle(
          color: GlassTheme.textColor(context),
          fontWeight: FontWeight.w900,
          fontSize: 16,
          letterSpacing: 2.0,
        ),
      ),
      centerTitle: true,
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
            color: GlassTheme.glassColor(context),
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
                  Text('ZINKO UK', style: TextStyle(color: GlassTheme.textColor(context), fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  Icon(Icons.contactless_rounded, color: GlassTheme.secondaryTextColor(context).withOpacity(0.4), size: 24),
                ],
              ),
              const SizedBox(height: 24),
              Text('AVAILABLE BALANCE', style: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              const SizedBox(height: 4),
              Text(
                '£${balance.toStringAsFixed(2)}',
                style: TextStyle(color: GlassTheme.textColor(context), fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -0.5),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('****  ****  ****  8888', style: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.6), fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                  Text('EXP 12/28', style: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.4), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutCubic).fadeIn();
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onTap, {bool highlight = false}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: highlight ? (isDark ? Colors.white : Colors.black) : GlassTheme.glassColor(context).withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: highlight ? (isDark ? Colors.white : Colors.black) : GlassTheme.glassBorder(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: highlight ? (isDark ? Colors.black : Colors.white) : GlassTheme.textColor(context)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: highlight ? (isDark ? Colors.black : Colors.white) : GlassTheme.textColor(context), letterSpacing: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionEntity tx) {
    final isCredit = tx.isCredit;
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: GlassTheme.glassColor(context).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GlassTheme.glassBorder(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCredit ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
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
                  Text(tx.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: GlassTheme.textColor(context))),
                  const SizedBox(height: 2),
                  Text(tx.date, style: TextStyle(fontSize: 11, color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Text(
              '${isCredit ? '+' : '-'} £${tx.amount.toInt()}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isCredit ? Colors.greenAccent : GlassTheme.textColor(context)),
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

  void _showGlassDialog({
    required BuildContext context,
    required String title,
    required String hint,
    String? prefix,
    TextInputType? keyboard,
    required Function(String) onConfirm,
  }) {
    final controller = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
              color: isDark ? const Color(0xFF0B1220) : Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: TextStyle(color: GlassTheme.textColor(context), fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.0)),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  keyboardType: keyboard,
                  autofocus: true,
                  style: TextStyle(color: GlassTheme.textColor(context), fontWeight: FontWeight.w800, fontSize: 18),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.3)),
                    prefixText: prefix,
                    prefixStyle: TextStyle(color: GlassTheme.textColor(context), fontWeight: FontWeight.w800),
                    filled: true,
                    fillColor: GlassTheme.textColor(context).withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text('CANCEL', style: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w900)),
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
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text('CONFIRM', style: TextStyle(fontWeight: FontWeight.w900)),
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
}

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassHeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
