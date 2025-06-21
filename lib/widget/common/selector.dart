import 'package:flutter/material.dart';
import '../../utility/theme.dart';

class Selector extends StatelessWidget {
  final TextEditingController controller;
  final String? defaultValue;
  final List<Map<String, dynamic>> allItems;
  final Function(String, String) onItemChanged;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool enabled;
  final String? Function(String?)? validator;
  final String valueKey;
  final String displayKey;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  
  Selector({
    super.key, 
    required this.controller, 
    this.defaultValue, 
    required this.allItems, 
    required this.onItemChanged,
    this.labelText = 'Item *',
    this.hintText,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
    this.valueKey = 'item',
    this.displayKey = 'item',
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
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
      child: DropdownButtonFormField<String>(
        decoration: AppTheme.inputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
        ).copyWith(
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        value: controller.text.isEmpty ? null : controller.text,
        items: allItems.map((item) {
          return DropdownMenuItem<String>(
            value: item[valueKey] as String,
            child: Text(
              item[displayKey] as String,
              style: AppTheme.bodyStyle,
            ),
          );
        }).toList(),
        onChanged: enabled ? (newValue) {
          if (newValue != null) {
            onItemChanged(newValue, controller.text);
          }
        } : null,
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an item';
          }
          return null;
        },
        style: AppTheme.bodyStyle,
        icon: Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
        dropdownColor: AppTheme.cardBackground,
        isExpanded: true,
      ),
    );
  }
}
