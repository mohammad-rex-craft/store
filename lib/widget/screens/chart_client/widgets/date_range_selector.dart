import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelector extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(BuildContext, bool) onSelectDate;
  final DateFormat displayFormat;

  const DateRangeSelector({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onSelectDate,
    required this.displayFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Date Range',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('From'),
                  TextButton(
                    onPressed: () => onSelectDate(context, true),
                    child: Text(
                      displayFormat.format(startDate),
                      style: TextStyle(
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('To'),
                  TextButton(
                    onPressed: () => onSelectDate(context, false),
                    child: Text(
                      displayFormat.format(endDate),
                      style: TextStyle(
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
} 