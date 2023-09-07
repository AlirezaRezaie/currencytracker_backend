import 'package:dollartracker/widgets/utilities/Chart/individual_bar.dart';

class BarData {
  final double data1;
  final double data2;
  final double data3;
  final double data4;

  BarData({
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
  });

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = [
      IndividualBar(x: 0, y: data1),
      IndividualBar(x: 1, y: data2),
      IndividualBar(x: 2, y: data3),
      IndividualBar(x: 3, y: data4),
    ];
  }


}
