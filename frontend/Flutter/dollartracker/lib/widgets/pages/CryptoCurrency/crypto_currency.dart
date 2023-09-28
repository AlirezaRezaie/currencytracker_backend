import 'package:dollartracker/widgets/pages/CryptoCurrency/crypto_currency_table.dart';
import 'package:dollartracker/widgets/utilities/currency_update_table.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utilities/Menu/side_menu.dart';
import '../../utilities/currency_selector.dart';

class CryptoCurrency extends StatefulWidget {
  const CryptoCurrency({super.key});

  @override
  State<CryptoCurrency> createState() => _CryptoCurrencyState();
}

class _CryptoCurrencyState extends State<CryptoCurrency> {
  List<bool> _selection = [
    false,
    false,
    true,
  ];
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
            height: 25,
          ),
          Text(
            "\$ 245000",
            style: GoogleFonts.monoton(
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          Text(
            "قیمت بیتکوین در حال حاظر",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontFamily: "IransansBlack",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          CurrencySelector(
            listOfCurrency: [
              'USD',
              'btn',
              'fsdd',
            ],
            width: 320,
            height: 60,
            getCurrency: (currency) {},
          ),
          SizedBox(
            height: 15,
          ),
          ToggleButtons(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "یورو",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'IransansBlack',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "دلار",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'IransansBlack',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "ریال",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    fontFamily: 'IransansBlack',
                  ),
                ),
              ),
            ],
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            fillColor: Theme.of(context).colorScheme.primary,
            splashColor: Theme.of(context).colorScheme.primary,
            isSelected: _selection,
            onPressed: (int newValue) {
              setState(() {
                for (int index = 0; index < _selection.length; index++) {
                  if (index == newValue) {
                    _selection[index] = true;
                  } else {
                    _selection[index] = false;
                  }
                }
              });
            },
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
              child: Container(
                color: Theme.of(context).colorScheme.tertiary,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 12.0),
                        height: 4.0,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "تغییرات قیمت بیتکوین",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(25),
                        physics: BouncingScrollPhysics(),
                        children: [
                          CryptoCurrencyTable(
                            volatility: "volatility",
                            price: "20",
                            time: "time",
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            priceColor: Colors.white,
                            imageLink:
                                "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                            name: 'name',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
