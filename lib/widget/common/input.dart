import 'package:flutter/material.dart';
import '../../utility/theme.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? defaultValue;
  final String? hintText;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final bool readOnly;
  final bool enabled;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final double? borderRadius;
  
  Input({
    super.key,
    required this.controller,
    required this.labelText,
    this.defaultValue,
    this.hintText,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.readOnly = false,
    this.enabled = true,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.obscureText = false,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.contentPadding,
    this.backgroundColor,
    this.borderRadius,
  }) {
    if (defaultValue != null) {
      controller.text = defaultValue!;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        enabled: enabled,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength,
        obscureText: obscureText,
        textInputAction: textInputAction,
        onTap: onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        focusNode: focusNode,
        style: AppTheme.bodyStyle,
        decoration: AppTheme.inputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          onSuffixPressed: onSuffixPressed,
        ).copyWith(
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}