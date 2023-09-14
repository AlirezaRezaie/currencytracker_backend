import 'package:flutter/material.dart';

class CurrencySelector extends StatefulWidget {
  final List<String> listOfCurrency;
  final double width, height;

  const CurrencySelector({
    super.key,
    required this.listOfCurrency,
    required this.width,
    required this.height,
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
            color:
                Color.fromARGB(255, 27, 28, 34), // Customize the border color
            width: 2.0, // Customize the border width
          ),
          color: Color.fromARGB(255, 27, 28, 34)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: current_currency,
          padding: EdgeInsets.symmetric(horizontal: 10),
          dropdownColor: Color.fromARGB(255, 27, 28, 34),
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.menu_rounded),
          style: TextStyle(
            color: Colors.white,
          ),
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
        ),
      ),
    );
  }
}
