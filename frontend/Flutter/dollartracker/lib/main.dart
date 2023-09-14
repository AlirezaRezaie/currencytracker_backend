import 'package:dollartracker/widgets/pages/about.dart';
import 'package:dollartracker/widgets/pages/currency_calculator.dart';
import 'package:dollartracker/widgets/pages/home.dart';
import 'package:dollartracker/widgets/pages/News/news.dart';
import 'package:dollartracker/widgets/pages/special_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    routes: {
      "/home": (context) => Home(),
      '/calculator': (context) => CurrencyCalculator(),
      '/news': (context) => NewsPage(),
      '/special_currency' :(context) => SpecialCurrency(),
      '/about': (context) => AboutPage(),
    },
  ));
}
