import 'package:dollartracker/widgets/utilities/currency_selector.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/Menu/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Header(
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            color: Colors.white,
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
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
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          CurrencySelector(
                            listOfCurrency: [
                              'USD',
                              'EUR',
                              'GBP',
                              'JPY',
                              'AUD',
                            ],
                            width: 100,
                            height: 60,
                          )
                        ],
                      ),
                    ),
                    Text(
                      " : ارز مورد نظر را انتخواب کنید",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          CurrencySelector(
                            listOfCurrency: [
                              'USD',
                              'EUR',
                              'GBP',
                              'JPY',
                              'AUD',
                            ],
                            width: 100,
                            height: 60,
                          )
                        ],
                      ),
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
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 110,
                      height: 60,
                      padding: EdgeInsets.only(left: 8),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits (0-9)
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(255, 27, 28, 34),
                          hintTextDirection: TextDirection.rtl,
                          hintText: "مثال: 12",
                          hintStyle: TextStyle(
                            color: Color.fromARGB(150, 255, 255, 255),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      " : مقدار ارز مورد نظر",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                  ],
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
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
