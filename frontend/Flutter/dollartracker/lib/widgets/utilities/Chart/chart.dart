import 'package:dollartracker/widgets/utilities/Chart/bar_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List data;

  const Chart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    BarData chartData =
        BarData(data1: data[0], data2: data[1], data3: data[2], data4: data[3]);
    chartData.initializeBarData();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: Color.fromARGB(40, 255, 255, 255), strokeWidth: 2);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: Color.fromARGB(40, 255, 255, 255), strokeWidth: 2);
          },
          drawHorizontalLine: true,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color.fromARGB(40, 255, 255, 255), width: 2),
        ),
        
        lineBarsData: [
          LineChartBarData(
              spots: [
                FlSpot(22, 50000),
                FlSpot(22, 50000),
                FlSpot(21, 60000),
                FlSpot(20, 70000),
                FlSpot(19, 55000),
                FlSpot(18, 70000),
                FlSpot(17, 80000),
                FlSpot(16, 55000),
                FlSpot(12, 60000),
                FlSpot(8, 75000),
                FlSpot(6, 45000),
                FlSpot(2, 55000),
                FlSpot(1, 55000),
              ],
              isCurved: true,
              color: const Color.fromARGB(255, 60, 80, 250),
              barWidth: 3,
              belowBarData: BarAreaData(
                  show: true, color: Color.fromARGB(90, 60, 79, 250)))
        ],
        maxX: 24,
        minX: 0,
      ),
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
