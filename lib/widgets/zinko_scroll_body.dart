import 'package:flutter/material.dart';

/// A common scroll wrapper that provides consistent [BouncingScrollPhysics]
/// and standard horizontal padding across the project.
class ZinkoScrollBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ZinkoScrollBody({
    super.key,
    required this.child,
    this.padding,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: child,
    );
  }
}
