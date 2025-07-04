import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final Map<double, String> monthLabels;
  final double maxY;

  const ChartWidget({
    super.key,
    required this.spots,
    required this.monthLabels,
    required this.maxY,
  });


  @override
  Widget build(BuildContext context) {
    // حساب القيم الحدية بطريقة أكثر دقة
    final double safeMaxY = maxY > 0 ? maxY * 1.2 : 10; // حد أدنى 10 إذا كانت القيم صغيرة
    final double intervalY = _calculateInterval(safeMaxY);
    final double minX = spots.isNotEmpty ? spots.first.x - 0.5 : 0;
    final double maxX = spots.isNotEmpty ? spots.last.x + 0.5 : 12;

    return Container(
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            'Total Orders',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 4, bottom: 4),
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toInt()} Order',
                            const TextStyle(color: Colors.white),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: intervalY,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (!monthLabels.containsKey(value) || 
                              value < minX || value > maxX) {
                            return const Text('');
                          }
                          return Transform.rotate(
                            angle: -0.5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                monthLabels[value]!,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: intervalY,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value > safeMaxY) {
                            return const Text('');
                          }
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: Colors.teal.shade700,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.teal.shade700,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.teal.withOpacity(0.3),
                            Colors.teal.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ],
                  minX: minX,
                  maxX: maxX,
                  minY: 0,
                  maxY: safeMaxY,
                  clipData: const FlClipData.all(), // منع الرسم خارج الحدود
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 10) return 2;
    if (maxValue <= 50) return 5;
    if (maxValue <= 100) return 10;
    if (maxValue <= 500) return 50;
    return 100;
  }
}