import 'package:flutter/material.dart';
import '../../utility/theme.dart';
import 'input.dart';

class SearchSortBar extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) filterData;
  final Function() sortDataByDate;
  const SearchSortBar({
    super.key,
    required this.searchController,
    required this.filterData,
    required this.sortDataByDate,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Input(
              controller: searchController,
              labelText: 'Search by Date or NO',
              prefixIcon: Icons.search,
              onChanged: filterData,
              keyboardType: TextInputType.text,
            ),
          ),
          IconButton(
            icon: Icon(Icons.sort, color: AppTheme.colorMain),
            onPressed: sortDataByDate,
            tooltip: 'Sort by Date',
          ),
        ],
      ),
    );
  }
}