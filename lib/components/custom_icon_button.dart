import 'package:flutter/material.dart';

import '../resources/app_color.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    this.onTap,
    this.radius = 0,
    this.padding,
    this.color,
    this.outlineBorder,
    this.boxShadow,
    required this.icon,
  });
  final VoidCallback? onTap;
  final double radius;
  final Icon icon;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final BoxBorder? outlineBorder;
  final List<BoxShadow>? boxShadow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: padding,
          decoration: BoxDecoration(
              border: (outlineBorder != null && color == null)
                  ? outlineBorder
                  : null,
              color: color,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: boxShadow),
          child: icon),
    );
  }
}
