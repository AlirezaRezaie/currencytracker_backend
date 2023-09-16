import 'package:flutter/material.dart';

import '../../utilities/Menu/side_menu.dart';

class NewsPostPage extends StatelessWidget {
  final String image, title, content, readTime;

  const NewsPostPage({
    super.key,
    required this.image,
    required this.title,
    required this.content,
    required this.readTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Column(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit
                          .cover, // You can adjust the image fit as needed
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Row(
            children: [],
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Color.fromARGB(200, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
