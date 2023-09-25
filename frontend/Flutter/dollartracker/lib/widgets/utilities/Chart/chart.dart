import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final List data;

  const Chart({super.key, required this.data});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  bool shouldShowDot(FlSpot spot, LineChartBarData barData) {
    // Define a threshold for the minimum distance between dots to show them
    double minDistanceThreshold = 100; // Adjust this threshold as needed

    // Check the distance between the current spot and the previous one
    if (barData.spots.isEmpty) {
      // If it's the first data point, always show the dot
      return true;
    } else {
      // Calculate the distance between the current spot and the previous one
      double distance = (spot.x - barData.spots.last.x).abs();
      print(distance);
      // Check if the distance is greater than the threshold to show the dot
      return distance >= minDistanceThreshold;
    }
  }

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
        minX: 0, // Min X-axis value (time)
        maxX: 24, // Max X-axis value (adjust as needed)
        minY: 0, // Min Y-axis value (adjust as needed)
        maxY: 200000, // Max Y-axis value (adjust as needed)

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
            // Configure the appearance of the points (dots)
            dotData: FlDotData(
              show: true, // Set to true to display dots
              checkToShowDot: (spot, barData) => shouldShowDot(spot, barData),
              // Adjust the size of the dots here
              // You can also configure other dot properties like color, strokeWidth, etc.
            ),
            isCurved: true,
            color: Theme.of(context).colorScheme.primary,
            barWidth: 0.5,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          )
        ],

        titlesData: FlTitlesData(show: false),
      ),
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }
}
