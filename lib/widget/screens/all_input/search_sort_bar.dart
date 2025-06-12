import 'package:flutter/material.dart';



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
    return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Date or NO',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: filterData,
                    keyboardType: TextInputType.text,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.sort),
                  onPressed: sortDataByDate,
                  tooltip: 'Sort by Date',
                ),
              ],
            ),
          );

  }
}