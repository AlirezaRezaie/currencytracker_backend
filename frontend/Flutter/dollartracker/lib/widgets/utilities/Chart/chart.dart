import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List data;

  const Chart({super.key, required this.data});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: Theme.of(context).colorScheme.secondaryContainer,
                strokeWidth: 2);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
                color: Theme.of(context).colorScheme.secondaryContainer,
                strokeWidth: 2);
          },
          drawHorizontalLine: true,
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondaryContainer,
              width: 2),
        ),
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Theme.of(context).colorScheme.background,
        )),
        lineBarsData: [
          LineChartBarData(
            spots: widget.data.map((item) => FlSpot(item[0], item[1])).toList(),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
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
