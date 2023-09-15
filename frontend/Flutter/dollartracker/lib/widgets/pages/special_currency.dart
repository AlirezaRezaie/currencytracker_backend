import 'package:dollartracker/widgets/utilities/currency_selector.dart';
import 'package:dollartracker/widgets/utilities/new_updates_table.dart';
import 'package:flutter/material.dart';

import '../utilities/Menu/side_menu.dart';
import '../utilities/header.dart';

class SpecialCurrency extends StatefulWidget {
  const SpecialCurrency({super.key});

  @override
  State<SpecialCurrency> createState() => _SpecialCurrencyState();
}

class _SpecialCurrencyState extends State<SpecialCurrency> {
  @override
  Widget build(BuildContext context) {
    // set the currency list to map and display to the user
    List currency_list = [
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
      },
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
      },
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
      },
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
      },
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
      },
      {
        "title": "title",
        "subtitle": 'subtitle',
        "persent": 60.0,
        "imageLink": "imageLink",
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
            profileImage:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
          ),
          SizedBox(
            height: 30,
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
              width: 300,
              height: 60,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: currency_list.length,
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return NewUpdatesTable(
                  title: currency_list[index]['title'],
                  imageLink: currency_list[index]['imageLink'],
                  persent: currency_list[index]['persent'],
                  subtitle: currency_list[index]['subtitle'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
