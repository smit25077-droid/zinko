import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.isSelected
          ? _scaleAnimation
          : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) {
          if (!widget.isSelected) {
            _animationController.forward();
          }
        },
        onTapUp: (_) {
          if (!widget.isSelected) {
            _animationController.reverse();
          }
        },
        onTapCancel: () {
          if (!widget.isSelected) {
            _animationController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Container(
              width: 100,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? Theme.of(context).primaryColor
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha((0.2 * 255).round()),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).round()),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(widget.category),
                    size: 30,
                    color: widget.isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.category,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: widget.isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'co-working':
        return Icons.workspaces_outline;
      case 'café':
      case 'cafe':
        return Icons.local_cafe_outlined;
      case 'meeting room':
        return Icons.meeting_room_outlined;
      case 'private office':
        return Icons.business_outlined;
      case 'event space':
        return Icons.event_outlined;
      default:
        return Icons.work_outline;
    }
  }
}
