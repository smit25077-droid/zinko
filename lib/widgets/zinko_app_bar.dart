import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zinko_app/utils/glass_theme.dart';

class ZinkoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final double? elevation;
  final Color? backgroundColor;

  const ZinkoAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.showBackButton = true,
    this.onBackTap,
    this.elevation = 0,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          title: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: GlassTheme.textColor(context),
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: centerTitle,
          backgroundColor: backgroundColor ?? GlassTheme.glassColor(context).withValues(alpha: 0.1),
          elevation: elevation,
          surfaceTintColor: Colors.transparent,
          leading: leading ?? (showBackButton && Navigator.canPop(context)
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      color: GlassTheme.glassColor(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: GlassTheme.glassBorder(context)),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: GlassTheme.textColor(context),
                        size: 16,
                      ),
                      onPressed: onBackTap ?? () => Navigator.pop(context),
                    ),
                  ),
                )
              : null),
          actions: actions,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
