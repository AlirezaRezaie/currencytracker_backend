import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:flutter/material.dart';

import '../../utilities/Menu/side_menu.dart';
import '../../utilities/currency_selector.dart';

class CryptoCurrency extends StatefulWidget {
  const CryptoCurrency({super.key});

  @override
  State<CryptoCurrency> createState() => _CryptoCurrencyState();
}

class _CryptoCurrencyState extends State<CryptoCurrency> {
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
              Container(child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
