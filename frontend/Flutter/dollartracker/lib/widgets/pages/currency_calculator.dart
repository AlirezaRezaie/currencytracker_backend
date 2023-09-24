import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/widgets/utilities/currency_selector.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/Menu/side_menu.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class CurrencyCalculator extends StatefulWidget {
  const CurrencyCalculator({super.key});

  @override
  State<CurrencyCalculator> createState() => _CurrencyCalculatorState();
}

class _CurrencyCalculatorState extends State<CurrencyCalculator> {
  // i want to save the status of the internet connection
  bool isConnected = false;
  // set the value for the answer section container i save them here
  // because i want to change it when user click on the submit button
  // and i want the container to be animation
  double _answerOpacity = 0;
  BorderRadius answerBorderRadius = BorderRadius.circular(0);
  EdgeInsets answerPadding = EdgeInsets.only(top: 80);
  Duration answerDuration = Duration(milliseconds: 300);

  // store the calculated currency
  double calculatedData = 0;

  // get the number of currency to calculate
  int number_of_currency = 0;

  // track if the data is fetching or not
  // for shoing the loading to the user while the data is fetching
  bool isFetchingData = false;

  // list of currencies to show user
  List<String> currencyList = [];

  // get the currency to calculate
  String firstCurrency = '';
  String secondCurrency = '';

  // get the host name
  String? host = dotenv.env['SERVER_HOST'];
  // check the internet connection
  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  // change the container values
  showAnswer() {
    setState(() {
      _answerOpacity = 1;
      answerBorderRadius = BorderRadius.circular(25);
      answerPadding = EdgeInsets.only(top: 60);
    });
  }

  // a function for fetch the live price of the currency and calculate the price
  Future<void> calculate() async {
    isFetchingData = true;
    final response = await http.get(
      Uri.parse(
        'http://$host/calculator/$firstCurrency:$secondCurrency',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    // if the fetch is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      // calculate the price
      setState(() {
        calculatedData = (data['from'] * number_of_currency) / data['to'];
      });
      isFetchingData = false;
      showAnswer();
    } else {
      // If the server did not return a 200 OK response
      print("Error");
      showFlash();
    }
  }

  // fetch the list of currencies
  Future<void> getCurrencyList() async {
    final response = await http.get(
      Uri.parse(
        'http://$host/counter/get_supported',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    // if the fetch is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      // You can now work with the data
      currencyList = data.keys.toList();
    } else {
      // If the server did not return a 200 OK response
      print("Error");
      showFlash();
    }
  }

  // a flash message to show user the internet is not connected
  showFlash() {
    context.showFlash<bool>(
      duration: const Duration(seconds: 8),
      builder: (context, controller) => FlashBar(
        controller: controller,
        behavior: FlashBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: Color.fromARGB(255, 15, 15, 16),
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        margin: const EdgeInsets.all(32.0),
        clipBehavior: Clip.antiAlias,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Color.fromARGB(255, 15, 15, 16),
        indicatorColor: Color.fromARGB(255, 255, 204, 0),
        icon: Icon(BootstrapIcons.exclamation_circle),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'مشکل در اتصال به اینترنت',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'IransansBlack',
            ),
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'بنظر میرسد اتصال اینترنت شما دچار مشکل شده است لطفا از اتصال اینترنت خود اطمینان حاصل فرمایید و سپس دوباره تلاش کنید',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.w400,
              fontSize: 10,
              fontFamily: 'IransansBlack',
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // fetch the list of currencies
    getCurrencyList();
    // check the internet connection
    checkNetworkStatus();
  }

  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // check the internet connection every 1 second
    Future.delayed(Duration(seconds: 1), () {
      checkNetworkStatus();
    });

    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Header(
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            color: Theme.of(context).colorScheme.onPrimary,
            profileImage:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
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
                    color: Theme.of(context).colorScheme.onPrimary,
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
                            listOfCurrency: currencyList,
                            width: 100,
                            height: 60,
                            getCurrency: (currency) => firstCurrency = currency,
                          )
                        ],
                      ),
                    ),
                    Text(
                      " : ارز مورد نظر را انتخواب کنید",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
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
                            listOfCurrency: currencyList,
                            width: 100,
                            height: 60,
                            getCurrency: (currency) =>
                                secondCurrency = currency,
                          )
                        ],
                      ),
                    ),
                    Text(
                      " : ارز دوم را انتخواب کنید",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
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
                        controller: _textEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Allow only digits (0-9)
                        ],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          hintTextDirection: TextDirection.rtl,
                          hintText: "مثال: 12",
                          hintStyle: TextStyle(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
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
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
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
                      onPressed: () {
                        if (isConnected) {
                          // get the coverted currency and show to the user
                          number_of_currency = _textEditingController.text == ''
                              ? 1
                              : int.parse(_textEditingController.text);
                          calculate();
                        } else {
                          // show a network connection error to the user
                          showFlash();
                          checkNetworkStatus();
                        }
                      },
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
                          Theme.of(context).colorScheme.primary,
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
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'IransansBlack',
                        ),
                      ),
                    ),
                  ],
                ),
                isFetchingData
                    ? Container(
                        width: 400,
                        height: 350,
                        child: Lottie.asset("assets/Loading3.json"),
                      )
                    : AnimatedPadding(
                        duration: answerDuration,
                        padding: answerPadding,
                        child: AnimatedOpacity(
                          opacity: _answerOpacity,
                          duration: answerDuration,
                          child: AnimatedContainer(
                              padding:
                                  EdgeInsets.only(top: 25, right: 20, left: 20),
                              duration: answerDuration,
                              width: 350,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary,
                                borderRadius: answerBorderRadius,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    spreadRadius: 1,
                                    blurRadius: 35,
                                    offset: Offset(0, 30),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Transform.rotate(
                                          angle: -30 * 3.14159265359 / 180,
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: 3,
                                              right: 3,
                                              left: 3,
                                              bottom: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                width: 3,
                                              ),
                                            ),
                                            child: Icon(
                                              BootstrapIcons.currency_dollar,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              size: 35,
                                            ),
                                          )),
                                      Text(
                                        " : مقدار ارز تبدیل شده",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'IransansBlack',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    calculatedData.toStringAsFixed(6),
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      fontFamily: 'IransansBlack',
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      "تبدیل ارز شما بر اساس جدید ترین قیمت ارز ها بوده، همچنین میتوانید این ارز ها رو درون اپلیکیشن بصورت جداگانه مشاهده کنید",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        fontFamily: 'IransansBlack',
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
    );
  }
}
