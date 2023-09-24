import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/widgets/utilities/currency_selector.dart';
import 'package:dollartracker/widgets/utilities/currency_table.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lottie/lottie.dart';
import '../utilities/Menu/side_menu.dart';
import '../utilities/header.dart';
import '../utilities/network_error.dart';
import 'package:http/http.dart' as http;
import 'package:dollartracker/services/get_time_for_iran.dart';

class SpecialCurrency extends StatefulWidget {
  const SpecialCurrency({super.key});

  @override
  State<SpecialCurrency> createState() => _SpecialCurrencyState();
}

class _SpecialCurrencyState extends State<SpecialCurrency> {
  bool isLoading = false;
  bool isNetworkConnected = false;

  bool isLoadingCurrencyList = false;
  // get the host name
  String? host = dotenv.env['SERVER_HOST'];

  // list of currencies to show user
  List<String> currencyList = [];

  // the currency that we want to show the list of them to the user
  String selectedCurrency = 'USD';

  // set the currency list to map and display to the user
  List data_list = [];

  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isNetworkConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> getCurrencyList() async {
    isLoadingCurrencyList = true;
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
      setState(() {
        currencyList = data.keys.toList();
        isLoadingCurrencyList = false;
      });
      getCurrencyData();
    } else {
      // If the server did not return a 200 OK response
      print("Error");
      showFlash();
      getCurrencyList();
    }
  }

  Future<void> getCurrencyData() async {
    isLoading = true;
    final response = await http.get(
      Uri.parse(
        'http://$host/counter/get_last/$selectedCurrency/0/40',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    // if the fetch is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      // You can now work with the data
      setState(() {
        data_list = data.toList().reversed.toList(); // Reverse the list here
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Header(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            color: Theme.of(context).colorScheme.onBackground,
            profileImage:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CurrencySelector(
                  listOfCurrency: currencyList,
                  width: 320,
                  height: 60,
                  getCurrency: (currency) {
                    setState(() {
                      selectedCurrency = currency;
                      getCurrencyData();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          isNetworkConnected
              ? isLoadingCurrencyList
                  ? Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: 400,
                          height: 400,
                          child: Lottie.asset("assets/Loading3.json"),
                        ),
                        Text(
                          "... در حال بارگیری لیست ارز ها",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ],
                    )
                  : isLoading
                      ? Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 400,
                              height: 400,
                              child: Lottie.asset("assets/Searching.json"),
                            ),
                            Text(
                              "... در حال بارگیری اطلاعات",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                fontFamily: 'IransansBlack',
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: data_list.length,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemBuilder: (context, index) {
                              if (data_list[index]['rateofchange'] == null ||
                                  data_list[index]['rateofchange'] == 0)
                                return SizedBox();
                              return CurrencyTable(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                price: data_list[index]['price'],
                                persentColor:
                                    data_list[index]['rateofchange'] != null
                                        ? data_list[index]['rateofchange'] > 0
                                            ? Colors.greenAccent
                                            : Colors.redAccent
                                        : Colors.white,
                                time: getTimeForIran(
                                    data_list[index]['posttime']),
                                imageLink:
                                    data_list[index]['rateofchange'] != null
                                        ? data_list[index]['rateofchange'] > 0
                                            ? 'assets/upArrow.png'
                                            : 'assets/downArrrow.png'
                                        : 'assets/line.png',
                                persent:
                                    data_list[index]['rateofchange'] == null
                                        ? 0
                                        : data_list[index]['rateofchange'],
                                volatility:
                                    data_list[index]['rateofchange'] != null
                                        ? data_list[index]['rateofchange'] > 0
                                            ? 'صعودی'
                                            : 'نزولی'
                                        : 'نامشخص',
                              );
                            },
                          ),
                        )
              : !isNetworkConnected
                  ? Padding(
                      padding: EdgeInsets.only(top: 90),
                      child: NetworkError(
                        onPress: () {
                          // recheck the internet connection
                          checkNetworkStatus();
                        },
                      ),
                    )
                  : SizedBox.shrink()
        ],
      ),
    );
  }
}
