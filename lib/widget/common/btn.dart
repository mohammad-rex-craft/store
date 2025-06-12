import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  static const Color primeColor = Color(0xFF03A9F4);
  final String title;
  final Color color;
  final double? height;
  final double width;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;


  const Btn({
    super.key, 
    required this.title,
    this.color = primeColor,
    this.height,
    this.width = 100,
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
    this.onTap,
    this.textStyle,
    this.padding,
    this.border,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}