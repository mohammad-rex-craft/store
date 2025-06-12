import 'package:flutter/material.dart';



class PaginationBtn extends StatelessWidget {
  final int currentPage;
  final bool hasMoreData;
  final Function() previousPage;
  final Function() nextPage;
  const PaginationBtn({
    super.key,
    required this.currentPage,
    required this.hasMoreData,
    required this.previousPage,
    required this.nextPage,
  });
  @override
  Widget build(BuildContext context) {
    return  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0 ? previousPage : null,
                  child: Text('Prev'),
                ),
                SizedBox(width: 20),
                Text(
                  'Page ${currentPage + 1}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: hasMoreData ? nextPage : null,
                  child: Text('Next'),
                ),
              ],
            ),
          );

  }
}