import 'package:flutter/material.dart';

class GoldDataTable extends StatelessWidget {
  final String time, imageLink, name;
  final double price, rateOfChange;
  final Color backgroundColor, priceColor, presentColor;

  const GoldDataTable({
    super.key,
    required this.presentColor,
    required this.rateOfChange,
    required this.price,
    required this.time,
    required this.backgroundColor,
    required this.priceColor,
    required this.imageLink,
    required this.name,
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
                  Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: Text(
                      "\$" + price.toString(),
                      style: TextStyle(
                        color: priceColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                  ),
                  Text(
                    "%" + rateOfChange.toString(),
                    style: TextStyle(
                      color: presentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
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
                          name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
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
                              fontSize: 11,
                              color: Theme.of(context).colorScheme.onPrimary,
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
