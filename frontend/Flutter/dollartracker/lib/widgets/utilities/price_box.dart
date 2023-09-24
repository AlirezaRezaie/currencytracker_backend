import 'package:flutter/material.dart';
import 'package:animated_digit/animated_digit.dart';

class PriceBox extends StatefulWidget {
  final String title;
  final AnimatedDigitWidget price;
  final Color firstColor;
  final Color secondColor;

  PriceBox({
    required this.title,
    required this.price,
    required this.firstColor,
    required this.secondColor,
  });

  @override
  State<PriceBox> createState() => _PriceBoxState();
}

class _PriceBoxState extends State<PriceBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.firstColor,
            widget.secondColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.only(top: 20, right: 45, bottom: 20, left: 45),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center, // Center the content vertically
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center the content horizontally
        children: [
          Text(
            "قیمت مستقیم صرافی",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
              fontWeight: FontWeight.w600,
              fontSize: 9,
              fontFamily: 'Iransans',
            ),
          ),
          Text(
            widget.title,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'IransansBlack',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: widget.price,
          ),
        ],
      ),
    );
  }
}
