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
                color: Theme.of(context).colorScheme.secondaryContainer, strokeWidth: 2);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: Theme.of(context).colorScheme.secondaryContainer, strokeWidth: 2);
          },
          drawHorizontalLine: true,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondaryContainer, width: 2),
        ),
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Theme.of(context).colorScheme.background,
        )),
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
            color : Theme.of(context).colorScheme.primary,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )
        ],
        maxX: 24,
        minX: 0,
        titlesData: FlTitlesData(show: false),
      ),
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
