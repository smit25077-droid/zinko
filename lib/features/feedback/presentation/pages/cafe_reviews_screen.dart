import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class CafeReviewsScreen extends StatefulWidget {
  static const String routeName = '/CafeReviewsScreen';
  final int cafeId;
  final String cafeName;

  const CafeReviewsScreen({
    super.key,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  State<CafeReviewsScreen> createState() => _CafeReviewsScreenState();
}

class _CafeReviewsScreenState extends State<CafeReviewsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FeedbackBloc>().add(GetCafeReviewsEvent(widget.cafeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'CAFE REVIEWS',
              style: TextStyle(
                color: GlassTheme.textColor(context),
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              widget.cafeName.toUpperCase(),
              style: TextStyle(
                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.6),
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocBuilder<FeedbackBloc, FeedbackState>(
            builder: (context, state) {
              if (state is FeedbackLoading) {
                return Center(child: CircularProgressIndicator(color: GlassTheme.textColor(context)));
              } else if (state is FeedbackReviewsLoaded) {
                if (state.reviews.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.reviews.length,
                  itemBuilder: (context, index) {
                    final review = state.reviews[index];
                    return _ReviewCard(review: review)
                        .animate()
                        .fadeIn(delay: (index * 50).ms)
                        .slideY(begin: 0.1, end: 0);
                  },
                );
              } else if (state is FeedbackError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 64,
            color: GlassTheme.textColor(context).withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            'NO REVIEWS YET',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: GlassTheme.textColor(context).withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final dynamic review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GlassTheme.glassColor(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GlassTheme.glassBorder(context).withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.amber.withValues(alpha: 0.1),
                    child: Icon(Icons.person_rounded, size: 14, color: Colors.amber),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'User #${review.userId}',
                    style: TextStyle(
                      color: GlassTheme.textColor(context),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              RatingBarIndicator(
                rating: double.tryParse(review.reviewStar) ?? 0,
                itemBuilder: (context, index) => const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 14.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.reviewText,
            style: TextStyle(
              color: GlassTheme.textColor(context).withValues(alpha: 0.8),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(review.reviewDate),
                style: TextStyle(
                  color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
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
