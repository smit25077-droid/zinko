import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;
  final ImageProvider<Object>? image;
  final Color? backgroundColor;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;

  const ZinkoBackground({
    super.key,
    this.child,
    this.showOverlay = true,
    this.image,
    this.backgroundColor,
    this.title,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Static Background Layer
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.glassBlack,
              image: DecorationImage(
                image: image ?? const AssetImage('assets/images/cafe_hotel_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                // opacity: 0.4,
              ),
            ),
            child: showOverlay
                ? Container(
                    decoration: BoxDecoration(
                      color: backgroundColor ??  Colors.black.withValues(alpha: 0.5),
                    ),
                  )
                : null,
          ),
        ),  
        // Content Layer
        if (child != null) child!,
      ],
    );
  }
}
//import 'package:flutter/material.dart';
// import 'package:zinko_app/core/theme/app_colors.dart';
// import 'package:zinko_app/widgets/zinko_app_bar.dart';
// import 'package:zinko_app/widgets/zinko_scroll_body.dart';
//
// class ZinkoBackground extends StatelessWidget {
//   final Widget? child;
//   final bool showOverlay;
//   final ImageProvider<Object>? image;
//   final Color? backgroundColor;
//   final String? title;
//   final Widget? titleWidget;
//   final Widget? leading;
//   final List<Widget>? actions;
//   final Widget? bottomNavigationBar;
//   final bool isScrollable;
//   final bool extendBodyBehindAppBar;
//   final EdgeInsetsGeometry? padding;
//
//   const ZinkoBackground({
//     super.key,
//     this.child,
//     this.showOverlay = true,
//     this.image,
//     this.backgroundColor,
//     this.title,
//     this.titleWidget,
//     this.leading,
//     this.actions,
//     this.bottomNavigationBar,
//     this.isScrollable = true,
//     this.extendBodyBehindAppBar = true,
//     this.padding,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       clipBehavior: Clip.none,
//       children: [
//         // Static Background Layer
//         Positioned.fill(
//           child: Container(
//             decoration: BoxDecoration(
//               color: backgroundColor ?? AppColors.glassBlack,
//               image: DecorationImage(
//                 image: image ?? const AssetImage('assets/images/cafe_hotel_bg.png'),
//                 fit: BoxFit.cover,
//                 alignment: Alignment.topCenter,
//               ),
//             ),
//             child: showOverlay
//                 ? Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black.withValues(alpha: 0.5),
//                     ),
//                   )
//                 : null,
//           ),
//         ),
//         // Content Layer
//         Scaffold(
//           backgroundColor: Colors.transparent,
//           extendBodyBehindAppBar: extendBodyBehindAppBar,
//           appBar: title != null || titleWidget != null || actions != null || leading != null
//               ? ZinkoAppBar(
//                   title: title ?? "",
//                   titleWidget: titleWidget,
//                   actions: actions,
//                   leading: leading,
//                 )
//               : null,
//           body: child != null
//               ? (isScrollable
//                   ? ZinkoScrollBody(padding: padding, child: child!)
//                   : SafeArea(child: child!))
//               : null,
//           bottomNavigationBar: bottomNavigationBar,
//         ),
//       ],
//     );
//   }
// }