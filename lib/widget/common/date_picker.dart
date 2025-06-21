import 'package:flutter/material.dart';
import '../../utility/theme.dart';

class DatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? defaultValue;
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool enabled;
  final String? Function(String?)? validator;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Color? backgroundColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Function(DateTime)? onDateSelected;
  final String dateFormat;
  
  DatePicker({
    super.key, 
    required this.controller, 
    this.defaultValue,
    this.labelText = 'Date *',
    this.hintText,
    this.prefixIcon,
    this.enabled = true,
    this.validator,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
    this.onDateSelected,
    this.dateFormat = 'yyyy-MM-dd',
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
        decoration: AppTheme.inputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: Icons.calendar_today,
          onSuffixPressed: enabled ? () => _selectDate(context) : null,
        ).copyWith(
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        controller: controller,
        readOnly: true,
        enabled: enabled,
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        style: AppTheme.bodyStyle,
        onTap: enabled ? () => _selectDate(context) : null,
      ),
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.colorMain,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      String formattedDate;
      switch (dateFormat) {
        case 'yyyy-MM-dd':
          formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          break;
        case 'dd/MM/yyyy':
          formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          break;
        case 'MM/dd/yyyy':
          formattedDate = "${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}";
          break;
        default:
          formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      }
      
      controller.text = formattedDate;
      onDateSelected?.call(picked);
    }
  }
}
