import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import 'menu_item.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Color.fromARGB(255, 27, 28, 34),
      child: Padding(
        padding: EdgeInsets.only(top: 35, right: 10),
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
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              color: currentRoute == "/home"
                  ? Color.fromARGB(255, 60, 80, 250)
                  : Color.fromARGB(255, 27, 28, 34),
              routName: "home",
            ),
            MenuItem(
              title: "تبدیل ارز",
              icon: BootstrapIcons.house_fill,
              color: currentRoute == "/calculator"
                  ? Color.fromARGB(255, 60, 80, 250)
                  : Color.fromARGB(255, 27, 28, 34),
              routName: "calculator",
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              color: Color.fromARGB(255, 27, 28, 34),
              routName: "home",
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              color: Color.fromARGB(255, 27, 28, 34),
              routName: "home",
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              color: Color.fromARGB(255, 27, 28, 34),
              routName: "home",
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              color: Color.fromARGB(255, 27, 28, 34),
              routName: "home",
            ),
          ],
        ),
      ),
    );
  }
}
