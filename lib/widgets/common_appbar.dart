import 'package:flutter/material.dart';
import '../utils/glass_theme.dart';
import '../features/booking/presentation/pages/home_screen.dart';
import 'zinko_glass_box.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Color? color;
  final bool isBackEnable;
  final bool fromBackgroundNotification;
  final bool actionButton;
  final bool iconsPin;
  final dynamic userUpdateLocationResponse; // Simplified data type
  final Function()? onActionTap;
  final IconData? actionIcon;
  final void Function()? onTap;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double height;
  final bool centerTitle;

  const CommonAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.color,
    this.isBackEnable = true,
    this.fromBackgroundNotification = false,
    this.userUpdateLocationResponse,
    this.actionButton = false,
    this.iconsPin = false,
    this.onActionTap,
    this.onTap,
    this.actionIcon,
    this.actions,
    this.bottom,
    this.height = kToolbarHeight,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(height + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        color ?? GlassTheme.glassColor(context).withValues(alpha: isDark ? 0.3 : 0.6);
    final borderColor = GlassTheme.glassBorder(context);

    return AppBar(
      toolbarHeight: height,
      bottom: bottom,
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: centerTitle,

      // Leading Support
      leading: isBackEnable
          ? _AppBarButton(
              icon: Icons.chevron_left_rounded,
              onTap: onTap ??
                  () {
                    if (fromBackgroundNotification) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.routeName,
                        (route) => false,
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
            )
          : SizedBox(),

      // Title Support
      title: titleWidget ??
          Text(
            title ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              color: GlassTheme.textColor(context),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),

      // Actions Support (Pins, Refreshes, and Custom Actions)
      actions: actions ??
          [
            if (iconsPin)
              _AppBarButton(
                icon: Icons.location_pin,
                onTap: () {
                  // Navigate to RadiusMappingCircleScreen if it exists
                  // Navigator.pushNamed(context, '/radius-mapping', arguments: userUpdateLocationResponse);
                },
              ),
            if (actionButton)
              _AppBarButton(
                icon: actionIcon ?? Icons.refresh,
                onTap: onActionTap ?? () {},
              ),
            const SizedBox(width: 8),
          ],

      flexibleSpace: ZinkoGlassBox.thick(
        blur: 20,
        borderRadius: 0,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 0.5),
        ),
        color: backgroundColor,
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _AppBarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _AppBarButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
