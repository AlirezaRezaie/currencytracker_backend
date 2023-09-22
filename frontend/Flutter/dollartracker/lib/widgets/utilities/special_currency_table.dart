import 'package:flutter/material.dart';

class SpecialCurrencyTable extends StatelessWidget {
  final String currencyName;
  final int price;
  final String volatility;
  final double persent;
  final Color persentColor;
  final String imageLink;

  const SpecialCurrencyTable({
    super.key,
    required this.currencyName,
    required this.price,
    required this.volatility,
    required this.persent,
    required this.persentColor,
    required this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 27, 28, 34),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(126, 0, 0, 0),
              spreadRadius: 3,
              blurRadius: 20,
              offset: Offset(0, 7),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    price.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "$persent %",
                    style: TextStyle(
                      color: persentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            volatility,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(97, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(imageLink),
                      fit: BoxFit.cover,
                    )),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
