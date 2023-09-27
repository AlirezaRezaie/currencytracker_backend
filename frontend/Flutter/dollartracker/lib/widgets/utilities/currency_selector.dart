import 'package:flutter/material.dart';

class CurrencySelector extends StatefulWidget {
  final List<String> listOfCurrency;
  final double width, height;
  final Function(String) getCurrency;

  const CurrencySelector({
    super.key,
    required this.listOfCurrency,
    required this.width,
    required this.height,
    required this.getCurrency,
  });

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  String current_currency = "USD";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .secondary, // Customize the border color
            width: 2.0, // Customize the border width
          ),
          color: Theme.of(context).colorScheme.secondary),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: current_currency,
          padding: EdgeInsets.symmetric(horizontal: 10),
          dropdownColor: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.menu_rounded),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontFamily: "IransansBlack",
              fontWeight: FontWeight.bold),
          items: widget.listOfCurrency
              .map<DropdownMenuItem<String>>((String currency) {
            return DropdownMenuItem<String>(
                value: currency,
                child: Row(
                  children: [
                    Text(
                      "🇺🇸 $currency",
                    ),
                  ],
                ) // Display the currency name as the item
                );
          }).toList(),
          onChanged: (String? newValue) => {
            widget.getCurrency(newValue!),
            setState(() {
              current_currency = newValue;
            })
          },
        ),
      ),
    );
  }
}
