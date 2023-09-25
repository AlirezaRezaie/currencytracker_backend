import 'package:flutter/material.dart';

class CurrencyTable extends StatelessWidget {
  final String time, volatility, imageLink;
  final int price;
  final double persent;
  final Color persentColor, backgroundColor;

  const CurrencyTable({
    super.key,
    required this.volatility,
    required this.price,
    required this.time,
    required this.persent,
    required this.persentColor,
    required this.backgroundColor,
    required this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 18),
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 1,
              blurRadius: 12,
              offset: Offset(0, 6),
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
                      color: Theme.of(context).colorScheme.primaryContainer,
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
                          volatility,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage(imageLink),
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
