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
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              children: [
                NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),
                NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),NewUpdatesTable(
                  title: "title",
                  subtitle: 'subtitle',
                  persent: 60,
                  imageLink: "imageLink",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
