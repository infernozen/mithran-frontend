import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CropExpenseChart extends StatelessWidget {
  List<String> imagePaths;
  List<double> cropExpenses;
  CropExpenseChart(
      {super.key, required this.imagePaths, required this.cropExpenses});

  @override
  Widget build(BuildContext context) {
    double maxValue = cropExpenses.reduce(max);

    return Container(
      height: 250,
      padding: EdgeInsets.only(top: 30.0, right: 15.0, bottom: 15.0),
      child: BarChart(
        BarChartData(
          maxY: maxValue,
          minY: 0,
          gridData: FlGridData(
            show: true, // Show grid lines
            drawHorizontalLine: true, // Show horizontal lines
            verticalInterval: 1, // Adjust interval as needed
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: const Color(0xffe0e0e0), // Color of horizontal lines
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: false, // Hide the borders
            border: Border.all(
              color: Colors.transparent, // Set border color to transparent
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            // leftTitles:
            //     const AxisTitles(sideTitles: SideTitles(showTitles: true)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < imagePaths.length) {
                    return Container(
                        padding: EdgeInsets.only(top: 3.0),
                        child: Image.asset(
                            "assets/cropexpense/${imagePaths[index]}.png"));
                  }
                  return Text('');
                },
              ),
            ),
          ),
          barGroups: List.generate(cropExpenses.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: cropExpenses[index],
                  color: Color(0xffDCDEDD),
                  width: 25,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            );
          }),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String cropName = imagePaths[groupIndex];
                double cropProfit = cropExpenses[groupIndex];
                return BarTooltipItem(
                  '$cropName\n',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$cropProfit',
                      style: TextStyle(
                        color: Colors.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
