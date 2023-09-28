import 'package:dollartracker/theme/theme_provider.dart';
import 'package:dollartracker/widgets/pages/CryptoCurrency/crypto_currency.dart';
import 'package:dollartracker/widgets/pages/about.dart';
import 'package:dollartracker/widgets/pages/currency_calculator.dart';
import 'package:dollartracker/widgets/pages/home.dart';
import 'package:dollartracker/widgets/pages/News/news.dart';
import 'package:dollartracker/widgets/pages/Introduction/introduction_screen.dart';
import 'package:dollartracker/widgets/pages/profile.dart';
import 'package:dollartracker/widgets/pages/SpecialCurrency/special_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool completed = prefs.getBool('intro_completed') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/home',
          routes: {
            "/home": (context) => completed ? Home() : IntroductionScreen(),
            '/news': (context) => NewsPage(),
            '/calculator': (context) => CurrencyCalculator(),
            '/special_currency': (context) => SpecialCurrency(),
            '/crypto_currency': (context) => CryptoCurrency(),
            '/profile': (context) => ProfilePage(),
            '/about': (context) => AboutPage(),
          },
          theme: Provider.of<ThemeProvider>(context)
              .themeData, // Use the themeData here
        );
      },
    ),
  );
}
