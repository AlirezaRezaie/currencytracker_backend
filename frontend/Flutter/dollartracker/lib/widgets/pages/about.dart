import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utilities/header.dart';
import '../utilities/Menu/side_menu.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String phone_number = "tel:09172737360";
    final String github_url = "https://github.com/MRAdibi";
    final String email_address = "mailto:m.r.adibi125@gmail.com";
    final String telegram_address = "https://t.me/bachekhobb";

    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(70),
              bottomRight: Radius.circular(70),
            ),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/about_background.jpg'),
                  fit: BoxFit.cover, // You can adjust the image fit as needed
                ),
              ),
              child: Header(
                backgroundColor: Color.fromARGB(106, 0, 0, 0),
                color: Color.fromARGB(255, 255, 255, 255),
                profileImage:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "درباره کارنسی ترکر ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'IransansBlack',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد کتابهای زیادی در شصت و سه درصد گذشته حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد ",
                    style: TextStyle(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      fontFamily: 'IransansBlack',
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "راه های ارتباطی با ما ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    fontFamily: 'IransansBlack',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrlString(github_url);
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10,
                                bottom: 10,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 60, 80, 250),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Border radius
                              ),
                            ),
                          ),
                          child: Text(
                            "آدرس گیت هاب",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrlString(phone_number);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 60, 80, 250),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                        ),
                        child: Text(
                          "تماس با توسعه دهنده",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 180,
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrlString(telegram_address);
                          },
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10,
                                bottom: 10,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 60, 80, 250),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Border radius
                              ),
                            ),
                          ),
                          child: Text(
                            "آیدی تلگرام",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () {
                          launchUrlString(email_address);
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 60, 80, 250),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                        ),
                        child: Text(
                          "ایمیل توسعه دهنده",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
