import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/news_card.dart';
import 'package:flutter/material.dart';

import '../utilities/Menu/side_menu.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Column(
        children: [
          Header(
            profileImage:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg",
            color: Colors.white,
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 15,
              left: 15,
              bottom: 20,
            ),
            child: TextField(
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(BootstrapIcons.search),
                prefixIconColor: const Color.fromARGB(150, 255, 255, 255),
                filled: true,
                fillColor: Color.fromARGB(255, 27, 28, 34),
                hintTextDirection: TextDirection.rtl,
                hintText: "جستجوری خبر ...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(150, 255, 255, 255),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              physics: BouncingScrollPhysics(),
              children: [
                NewsCard(
                  thumbnail: "assets/about_background.jpg",
                  title:
                      "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ ",
                  topic: "اقتصاد",
                  time: "23 شهریور 1403 ساعت 9:23",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
