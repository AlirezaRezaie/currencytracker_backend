import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dollartracker/theme/theme.dart';
import 'package:dollartracker/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'menu_item.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: EdgeInsets.only(top: 35, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () =>
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme(),
                    child: Icon(
                      Provider.of<ThemeProvider>(
                                context,
                              ).themeData ==
                              lightMode
                          ? BootstrapIcons.moon_fill
                          : BootstrapIcons.sun_fill,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
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
                                color: Theme.of(context).colorScheme.onSecondary,
                                fontFamily: 'IransansBlack',
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            Text(
                              "خوش آمدی",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                fontFamily: 'IransansBlack',
                                fontWeight: FontWeight.bold,
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
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            MenuItem(
              title: "صفحه اصلی",
              icon: BootstrapIcons.house_fill,
              background_color: currentRoute == "/home"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/home"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "home",
            ),
            MenuItem(
              title: "تبدیل ارز",
              icon: BootstrapIcons.clipboard2_data_fill,
              background_color: currentRoute == "/calculator"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/calculator"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "calculator",
            ),
            MenuItem(
              title: "اخبار",
              icon: BootstrapIcons.newspaper,
              background_color: currentRoute == "/news"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/news"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "news",
            ),
            MenuItem(
              title: "ارز اختصاصی",
              icon: BootstrapIcons.currency_dollar,
              background_color: currentRoute == "/special_currency"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/special_currency"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "special_currency",
            ),
            MenuItem(
              title: "پروفایل",
              icon: BootstrapIcons.person_fill,
              background_color: currentRoute == "/profile"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/profile"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "profile",
            ),
            MenuItem(
              title: "درباره ما",
              icon: BootstrapIcons.info_circle_fill,
              background_color: currentRoute == "/about"
                  ? Theme.of(context).colorScheme.primary
                  : Color.fromARGB(0, 27, 28, 34),
              color: currentRoute == "/about"
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSecondary,
              routName: "about",
            ),
          ],
        ),
      ),
    );
  }
}
