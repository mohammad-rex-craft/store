import 'package:flutter/material.dart';
import '../../utility/theme.dart';

class Btn extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final List<BoxShadow>? shadow;
  final bool enabled;
  final bool isLoading;
  final IconData? icon;
  final double? iconSize;
  final MainAxisAlignment? iconAlignment;
  final double? elevation;
  final Gradient? gradient;
  final Widget? child;
  final BtnType btnType;
  
  const Btn({
    super.key, 
    required this.title,
    this.backgroundColor,
    this.textColor,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
    this.textStyle,
    this.padding,
    this.border,
    this.shadow,
    this.enabled = true,
    this.isLoading = false,
    this.icon,
    this.iconSize,
    this.iconAlignment,
    this.elevation,
    this.gradient,
    this.child,
    this.btnType = BtnType.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        onTap: enabled && !isLoading ? onTap : null,
        child: Container(
          height: height ?? 48,
          width: width,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            border: border ?? _getBorder(),
            boxShadow: shadow ?? _getShadow(),
            gradient: gradient,
          ),
          child: Center(
            child: Padding(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: isLoading 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                    ),
                  )
                : child ?? _buildContent(),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent() {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: iconAlignment ?? MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _getTextColor(),
            size: iconSize ?? 20,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: textStyle ?? TextStyle(
              color: _getTextColor(),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      );
    }
    
    return Text(
      title,
      style: textStyle ?? TextStyle(
        color: _getTextColor(),
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
  
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    
    switch (btnType) {
      case BtnType.primary:
        return AppTheme.colorMain;
      case BtnType.secondary:
        return Colors.transparent;
      case BtnType.success:
        return AppTheme.colorSuccess;
      case BtnType.warning:
        return AppTheme.colorWarning;
      case BtnType.error:
        return AppTheme.colorError;
      case BtnType.info:
        return AppTheme.colorInfo;
      case BtnType.outline:
        return Colors.transparent;
    }
  }
  
  Color _getTextColor() {
    if (textColor != null) return textColor!;
    
    switch (btnType) {
      case BtnType.primary:
      case BtnType.success:
      case BtnType.warning:
      case BtnType.error:
      case BtnType.info:
        return Colors.white;
      case BtnType.secondary:
      case BtnType.outline:
        return AppTheme.colorMain;
    }
  }
  
  BoxBorder? _getBorder() {
    switch (btnType) {
      case BtnType.outline:
        return Border.all(color: AppTheme.colorMain, width: 2);
      case BtnType.secondary:
        return Border.all(color: AppTheme.colorMain, width: 1);
      default:
        return null;
    }
  }
  
  List<BoxShadow>? _getShadow() {
    if (elevation != null) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: elevation!,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }
}

enum BtnType {
  primary,
  secondary,
  success,
  warning,
  error,
  info,
  outline,
}
