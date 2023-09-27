import 'package:dollartracker/widgets/pages/Introduction/intro_page_content.dart';
import 'package:dollartracker/widgets/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  PageController _controller = PageController();

  bool onLastPage = false;

// Function to check if the introduction has been completed
  Future<void> checkIntroCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool completed = prefs.getBool('intro_completed') ?? false;

    if (completed) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  // Function to save data to storage
  Future<void> saveDataToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(
        'intro_completed', true); // Replace 'key' and 'value' with your data
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIntroCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                onLastPage = value == 3;
              });
            },
            children: [
              IntroPageContent(
                title: "رصد لحظه ای قیمت ارز ها",
                description:
                    "با امکاناتی که ما برای شما در این اپلیکیشن تدارک دیدیم شما میتوانید جدید ترین قیمت بسیاری از ارز ها رو به صورت زنده مشاهده کنید",
                animationLink: "assets/Chart2.json",
              ),
              IntroPageContent(
                title: "بررسی قیمت به وسیله نمودار",
                description:
                    "میتوانید با بررسی نموداد نوسانات قیمت دلار رو بررسی کنید",
                animationLink: "assets/Chart.json",
              ),
              IntroPageContent(
                title: "بررسی قیمت به وسیله نمودار",
                description:
                    "میتوانید با بررسی نموداد نوسانات قیمت دلار رو بررسی کنید",
                animationLink: "assets/Chart.json",
              ),
              IntroPageContent(
                title: "بررسی قیمت به وسیله نمودار",
                description:
                    "میتوانید با بررسی نموداد نوسانات قیمت دلار رو بررسی کنید",
                animationLink: "assets/Chart.json",
              ),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.80),
            child: !onLastPage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // skip btn
                      ElevatedButton(
                        onPressed: () {
                          _controller.jumpToPage(3);
                        },
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.onSecondary,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                        ),
                        child: Text(
                          "رد کردن",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                      SmoothPageIndicator(
                        controller: _controller,
                        effect: JumpingDotEffect(
                            activeDotColor:
                                Theme.of(context).colorScheme.primary),
                        count: 4,
                      ),

                      // next page and done btn
                      ElevatedButton(
                        onPressed: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 700),
                            curve: Curves.easeInOutQuint,
                          );
                        },
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onBackground),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                              right: 20,
                              left: 20,
                              top: 10,
                              bottom: 10,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.onSecondary,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(8), // Border radius
                            ),
                          ),
                        ),
                        child: Text(
                          "بعدی",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      saveDataToStorage();
                      checkIntroCompleted();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.only(
                          right: 90,
                          left: 90,
                          top: 15,
                          bottom: 15,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8), // Border radius
                        ),
                      ),
                    ),
                    child: Text(
                      "بریم بترکونیم",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
