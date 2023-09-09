import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dollartracker/widgets/utilities/Chart/menu_item.dart';
import 'package:flutter/material.dart';
import './widgets/pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: Color.fromARGB(255, 27, 28, 34),
        child: Padding(
          padding: EdgeInsets.only(top: 50, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "سلام، علیرضا",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'IransansBlack',
                              fontSize: 17),
                        ),
                        Text(
                          "خوش آمدی",
                          style: TextStyle(
                            color: const Color.fromARGB(200, 255, 255, 255),
                            fontFamily: 'IransansBlack',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    // user profile
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chris_Hemsworth_by_Gage_Skidmore_2_%28cropped%29.jpg/220px-Chris_Hemsworth_by_Gage_Skidmore_2_%28cropped%29.jpg'),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 60, 80, 250),
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 27, 28, 34),
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 27, 28, 34),
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 27, 28, 34),
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 27, 28, 34),
              ),
              MenuItem(
                title: "صفحه اصلی",
                icon: BootstrapIcons.house_fill,
                color: Color.fromARGB(255, 27, 28, 34),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: const Home(),
    );
  }
}
