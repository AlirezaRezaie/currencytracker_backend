import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Header extends StatelessWidget {
  final String profileImage;
  final Color color;
  final Color backgroundColor;
  const Header({
    super.key,
    required this.profileImage,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      child: Column(
        children: [
          // add some padding to make space between the header and the top of the phone
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  // user profile
                  backgroundImage: NetworkImage(
                    profileImage,
                  ),
                ),
                Text(
                  "Currency Tracker",
                  style: GoogleFonts.aladin(
                    color: color,
                    fontSize: 25,
                  ),
                ),
                IconButton(
                  // here you can add functionality for the icon
                  onPressed: () {
                    // open the manu
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: Icon(
                    BootstrapIcons.list,
                    color: color,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
