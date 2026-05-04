import 'package:flutter/material.dart';

/// A common scroll wrapper that provides consistent [BouncingScrollPhysics]
/// and standard horizontal padding across the project.
class ZinkoScrollBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Axis scrollDirection;

  const ZinkoScrollBody({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.controller,
    this.scrollDirection = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: scrollDirection,
      controller: controller,
      physics: BouncingScrollPhysics() ?? physics,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}
