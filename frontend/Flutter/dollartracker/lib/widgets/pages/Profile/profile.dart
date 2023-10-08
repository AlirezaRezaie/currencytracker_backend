import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dollartracker/widgets/pages/Profile/setting_item.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utilities/Menu/side_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    BorderRadius imageBoxBorderRadius = BorderRadius.circular(15);
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Header(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            color: Theme.of(context).colorScheme.onBackground,
            profileImage:
                'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 165,
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 70,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "علیرضا رضایی",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      fontFamily: "IransansBlack",
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.shadow,
                                spreadRadius: 1,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              )
                            ],
                          ),
                          child: Text(
                            "m.r.adibi125@gmail.com",
                            style: GoogleFonts.lato(
                                fontSize: 25,
                                color:
                                    Theme.of(context).colorScheme.onTertiary),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SettingItem(
                          title: "تغییر تم",
                          icon: BootstrapIcons.palette_fill,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SettingItem(
                          title: "تغییر ارز صفحه اصلی",
                          icon: BootstrapIcons.currency_dollar,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -60,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: imageBoxBorderRadius,
                      ),
                      padding: EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: imageBoxBorderRadius,
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://assets.entrepreneur.com/content/3x2/2000/1694109712-ent23-septoct-cover-ChrisHemsworth-hero.jpg?format=pjeg&auto=webp',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
