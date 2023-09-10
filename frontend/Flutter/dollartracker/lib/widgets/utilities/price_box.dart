import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriceBox extends StatelessWidget {
  final String title;
  final int price;
  final Color firstColor;
  final Color secondColor;

  PriceBox({
    required this.title,
    required this.price,
    required this.firstColor,
    required this.secondColor,
  });

  @override
  Widget build(BuildContext context) {
    AnimatedDigitController _controller = AnimatedDigitController(price);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            firstColor,
            secondColor,
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
              color: Color.fromARGB(173, 255, 255, 255),
              fontWeight: FontWeight.w600,
              fontSize: 9,
              fontFamily: 'Iransans',
            ),
          ),
          Text(
            title,
            style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'IransansBlack'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              children: [
                AnimatedDigitWidget(
                  controller: _controller,
                  enableSeparator: true,
                  textStyle: GoogleFonts.aladin(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
