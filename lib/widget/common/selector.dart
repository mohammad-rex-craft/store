import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../../utility/theme.dart';

class Selector extends StatefulWidget {
  final TextEditingController controller;
  final String? defaultValue;
  final List<Map<String, dynamic>> allItems;
  final Function(dynamic) onItemChanged;
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
  final bool isMultiple;
  final List<String>? initialValue;

  const Selector({
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
    this.isMultiple = false,
    this.initialValue,
  });

  @override
  State<Selector> createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {
  List<String> _currentValues = [];

  @override
  void initState() {
    super.initState();
    if (widget.defaultValue != null) {
      widget.controller.text = widget.defaultValue!;
    }
    _currentValues = widget.initialValue ?? [];
  }

  @override
  void didUpdateWidget(covariant Selector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _currentValues = widget.initialValue ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMultiple) {
      return Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: MultiSelectDialogField(
          items: widget.allItems
              .map(
                (item) => MultiSelectItem<String>(
                  item[widget.valueKey] as String,
                  item[widget.displayKey] as String,
                ),
              )
              .toList(),
          title: Text(widget.labelText),
          selectedColor: AppTheme.colorMain,
          decoration: BoxDecoration(
            color: AppTheme.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor, width: 1),
          ),
          buttonIcon: Icon(
            Icons.arrow_drop_down,
            color: AppTheme.textSecondary,
          ),
          buttonText: Text(
            widget.labelText,
            style: AppTheme.bodyStyle.copyWith(color: AppTheme.textSecondary),
          ),
          onConfirm: (values) {
            setState(() {
              _currentValues = values.cast<String>();
            });
            widget.onItemChanged(values);
          },
          initialValue: _currentValues,
          chipDisplay: MultiSelectChipDisplay(
            items: _currentValues.map((e) => MultiSelectItem(e, e)).toList(),
            onTap: (value) {
              setState(() {
                _currentValues.remove(value);
              });
              widget.onItemChanged(_currentValues);
            },
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration:
            AppTheme.inputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              prefixIcon: widget.prefixIcon,
            ).copyWith(
              contentPadding:
                  widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
        value: widget.controller.text.isEmpty ? null : widget.controller.text,
        items: widget.allItems.map((item) {
          return DropdownMenuItem<String>(
            value: item[widget.valueKey] as String,
            child: Text(item[widget.displayKey] as String, style: AppTheme.bodyStyle),
          );
        }).toList(),
        onChanged: widget.enabled
            ? (newValue) {
                if (newValue != null) {
                  widget.onItemChanged(newValue);
                }
              }
            : null,
        validator:
            widget.validator ??
            (value) {
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
