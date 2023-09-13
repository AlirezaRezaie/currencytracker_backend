import 'package:dollartracker/widgets/utilities/currency_selector.dart';
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Header(
              profileImage:
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg",
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              "تبدیل لحظه ای ارز",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'IransansBlack',
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CurrencySelector(
                      listOfCurrency: [
                        'USD',
                        'EUR',
                        'GBP',
                        'JPY',
                        'AUD',
                      ],
                    )
                  ],
                ),
                Text(
                  " : ارز مورد نظر همراه با تعداد انتخواب کنید",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'IransansBlack',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CurrencySelector(
                      listOfCurrency: [
                        'USD',
                        'EUR',
                        'GBP',
                        'JPY',
                        'AUD',
                      ],
                    )
                  ],
                ),
                Text(
                  " : ارز دوم را انتخواب کنید",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: 'IransansBlack',
                  ),
                ),
              ],
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 27, 28, 34),
                hintTextDirection: TextDirection.rtl,
                hintText: "تعداد مورد نظر",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        right: 140,
                        left: 140,
                        top: 15,
                        bottom: 15,
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 60, 80, 250),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Border radius
                      ),
                    ),
                  ),
                  child: Text(
                    "تبدیل ارز",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
