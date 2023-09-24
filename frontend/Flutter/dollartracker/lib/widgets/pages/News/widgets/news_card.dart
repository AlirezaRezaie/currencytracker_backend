import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String thumbnail, topic, title, time;
  final Function onPress;

  const NewsCard({
    super.key,
    required this.thumbnail,
    required this.topic,
    required this.title,
    required this.time,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          topic,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Container(
                height: 90,
                width: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(thumbnail),
                    fit: BoxFit.cover, // You can adjust the image fit as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
