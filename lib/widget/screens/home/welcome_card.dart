import 'package:flutter/material.dart';
import '../../../utility/hooks.dart';
import '../../../database/database.dart';

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  final DatabaseService db = DatabaseService();
  List<Map<String, dynamic>> topItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTopOrderedItems();
  }

  Future<void> loadTopOrderedItems() async {
    try {
      setState(() {
        isLoading = true;
      });

      final topItemsList = await db.getTopOrderedItems(
        context: context,
        limit: 6,
        errorMessage: "Error loading top ordered items",
      );

      setState(() {
        topItems = topItemsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [hexToColor('#303F9F'), hexToColor('#1976D2')],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: hexToColor('#303F9F').withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Loading...',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Top Ordered Items',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white, size: 14),
                      onPressed: loadTopOrderedItems,
                      tooltip: 'Refresh',
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    ),
                  ],
                ),
                if (topItems.isEmpty)
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Text(
                      'No orders found',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 5.0,
                    ),
                    itemCount: topItems.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> item = topItems[index];
                      bool isLowStock = item['currentQty'] < 10;

                      return Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isLowStock
                                ? Colors.orange.withOpacity(0.5)
                                : Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 7,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    item['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 9,
                                ),
                                SizedBox(width: 1),
                                Text(
                                  '${item['frequency']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.white.withOpacity(0.7),
                                  size: 9,
                                ),
                                SizedBox(width: 1),
                                Text(
                                  '${item['currentQty']}',
                                  style: TextStyle(
                                    color: isLowStock
                                        ? Colors.orange.shade100
                                        : Colors.white,
                                    fontSize: 8,
                                    fontWeight: isLowStock
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                if (topItems.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 3),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Top ${topItems.length} items',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
    );
  }
}
