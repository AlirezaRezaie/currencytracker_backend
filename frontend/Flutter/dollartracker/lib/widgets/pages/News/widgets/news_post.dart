import 'package:flutter/material.dart';
import '../../../utilities/Menu/side_menu.dart';

class NewsPostPage extends StatelessWidget {
  final String image, title, content;
  final int readTime;

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
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(67, 255, 255, 255),
                      spreadRadius: 1,
                      blurRadius: 50,
                      offset: Offset(0, -10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Container(
                    width: 700,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(image),
                        fit: BoxFit
                            .cover, // You can adjust the image fit as needed
                      ),
                    ),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 17, top: 35),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(76, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 13, left: 13, bottom: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "$readTime دقیقه برای خواندن",
                    style: TextStyle(
                      color: Color.fromARGB(255, 223, 230, 233),
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 13),
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 236, 240, 241),
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
                      color: Color.fromARGB(200, 236, 240, 241),
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