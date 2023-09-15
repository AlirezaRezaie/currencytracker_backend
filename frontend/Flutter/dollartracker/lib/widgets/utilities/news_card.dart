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
                      Text(
                        topic,
                        style: TextStyle(
                          color: Color.fromARGB(255, 60, 80, 250),
                          fontWeight: FontWeight.w400,
                          fontSize: 9,
                          fontFamily: 'IransansBlack',
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          title,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
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
                        color: const Color.fromARGB(200, 255, 255, 255),
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
                    image: AssetImage(thumbnail),
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
