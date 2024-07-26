import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/chartdata.dart';

class ConstructBarChart extends StatelessWidget {
  final List<String> timeArr;
  final List<double> temperatureArr;

  ConstructBarChart(
      {super.key, required this.timeArr, required this.temperatureArr});

  @override
  Widget build(BuildContext context) {
    List<ChartData> chartData = [];
    double maxValue = temperatureArr.reduce(max);

    // Normalize the temperature values
    List<double> normalizedTemps = temperatureArr.map((temp) {
      return double.parse((temp / maxValue).toStringAsFixed(2));
    }).toList();

    // Prepare chart data
    for (int i = 0; i < timeArr.length; i++) {
      chartData.add(ChartData(timeArr[i], normalizedTemps[i]));
    }

    return Container(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: 1, // Since we normalized the data
          minY: 0,
          gridData: const FlGridData(
            show: false,
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < timeArr.length) {
                    return Container(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Text(timeArr[index],
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff6B6B6B))),
                    );
                  }
                  return Text('');
                },
                interval: 1,
              ),
            ),
          ),
          barGroups: List.generate(timeArr.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: chartData[index].temperature,
                  color: Colors.orange,
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
                String time = chartData[groupIndex].time;
                double temperature = temperatureArr[groupIndex];
                return BarTooltipItem(
                  '$time\n',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$temperature°C',
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