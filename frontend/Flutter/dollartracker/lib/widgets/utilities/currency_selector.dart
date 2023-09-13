import 'package:flutter/material.dart';

class CurrencySelector extends StatefulWidget {
  final List<String> listOfCurrency;

  const CurrencySelector({
    super.key,
    required this.listOfCurrency,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  String current_currency = "USD";

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: current_currency,
      dropdownColor: Color.fromARGB(255, 27, 28, 34),
      icon: Icon(Icons.menu_rounded),
      style: TextStyle(color: Colors.white),
      items: widget.listOfCurrency
          .map<DropdownMenuItem<String>>((String currency) {
        return DropdownMenuItem<String>(
            value: currency,
            child: Row(
              children: [
                Text("🇺🇸"),
                Text(
                  currency,
                ),
              ],
            ) // Display the currency name as the item
            );
      }).toList(),
      onChanged: (String? newValue) => {
        setState(() {
          current_currency = newValue!;
        })
      },
    );
  }
}
