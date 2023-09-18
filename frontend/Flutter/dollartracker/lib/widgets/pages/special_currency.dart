import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/widgets/utilities/Skeleton/currency_table_skeleton.dart';
import 'package:dollartracker/widgets/utilities/currency_selector.dart';
import 'package:dollartracker/widgets/utilities/special_currency_table.dart';
import 'package:flutter/material.dart';
import '../utilities/Menu/side_menu.dart';
import '../utilities/header.dart';
import '../utilities/network_error.dart';

class SpecialCurrency extends StatefulWidget {
  const SpecialCurrency({super.key});

  @override
  State<SpecialCurrency> createState() => _SpecialCurrencyState();
}

class _SpecialCurrencyState extends State<SpecialCurrency> {
  bool isLoading = false;
  bool isConnected = false;

  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    super.initState();
    checkNetworkStatus();
  }

  @override
  Widget build(BuildContext context) {
    // set the currency list to map and display to the user
    List currency_list = [
      {
        "title": "title",
        "price": 57000,
        "subtitle": 'subtitle',
        "persent": 25.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
      {
        "title": "title",
        "price": 58000,
        "subtitle": 'subtitle',
        "persent": -12.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
      {
        "title": "title",
        "price": 60000,
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
      {
        "title": "title",
        "price": 58000,
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
      {
        "title": "title",
        "price": 58000,
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
      {
        "title": "title",
        "price": 58000,
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink":
            "https://png.pngtree.com/png-vector/20190419/ourmid/pngtree-vector-up-arrow-icon-png-image_956434.jpg",
      },
    ];

    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Column(
        children: [
          Header(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            color: Colors.white,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: CurrencySelector(
                    listOfCurrency: [],
                    width: 100,
                    height: 60,
                  ),
                ),
                Container(
                  child: CurrencySelector(
                    listOfCurrency: [
                      'USD',
                      'EUR',
                      'GBP',
                      'JPY',
                      'AUD',
                    ],
                    width: 230,
                    height: 60,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          isConnected
              ? isLoading
                  ? Expanded(
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            CurrencyTableSkeleton(),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemCount: 8,
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: currency_list.length,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemBuilder: (context, index) {
                          return SpecialCurrencyTable(
                            price: currency_list[index]['price'],
                            persentColor: currency_list[index]['persent'] > 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            currencyName: currency_list[index]['title'],
                            imageLink: currency_list[index]['imageLink'],
                            persent: currency_list[index]['persent'],
                            volatility: currency_list[index]['subtitle'],
                          );
                        },
                      ),
                    )
              : !isConnected
                  ? Padding(
                      padding: EdgeInsets.only(top: 90),
                      child: NetworkError(
                        onPress: () {
                          // recheck the internet connection
                          checkNetworkStatus();
                        },
                      ),
                    )
                  : SizedBox()
        ],
      ),
    );
  }
}
