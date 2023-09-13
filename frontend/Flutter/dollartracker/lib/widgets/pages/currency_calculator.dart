import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/side_menu.dart';
import 'package:flutter/material.dart';

class CurrencyCalculator extends StatefulWidget {
  const CurrencyCalculator({super.key});

  @override
  State<CurrencyCalculator> createState() => _CurrencyCalculatorState();
}

class _CurrencyCalculatorState extends State<CurrencyCalculator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Header(
              profileImage:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg",
            ),
          ],
        ),
      ),
    );
  }
}
