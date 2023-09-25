import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CurrencyUpdateTable extends StatelessWidget {
  final String time, volatility, imageLink, name;
  final String price;
  final Color backgroundColor;

  const CurrencyUpdateTable({
    super.key,
    required this.volatility,
    required this.price,
    required this.time,
    required this.backgroundColor,
    required this.imageLink,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    String? host = dotenv.env['SERVER_HOST'];

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
              Padding(
                padding: EdgeInsets.only(top: 7),
                child: Text(
                  price,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IransansBlack',
                  ),
                ),
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
                            volatility,
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
                          image: NetworkImage('http://$host' + '$imageLink'),
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
