import 'package:flutter/material.dart';

import '../utilities/header.dart';
import '../utilities/side_menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(70),
          bottomRight: Radius.circular(70),
        ),
        child: Container(
          height: 400,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/about_background.jpg'),
              fit: BoxFit.cover, // You can adjust the image fit as needed
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Header(
                backgroundColor: Color.fromARGB(106, 0, 0, 0),
                color: Color.fromARGB(255, 255, 255, 255),
                profileImage:
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Dwayne_Johnson_2014_%28cropped%29.jpg/640px-Dwayne_Johnson_2014_%28cropped%29.jpg",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
