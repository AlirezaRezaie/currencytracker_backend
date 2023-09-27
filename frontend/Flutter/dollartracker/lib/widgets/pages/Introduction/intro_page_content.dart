import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageContent extends StatelessWidget {
  final String title, description, animationLink;

  const IntroPageContent({
    super.key,
    required this.title,
    required this.description,
    required this.animationLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'IransansBlack',
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Container(
            width: 250,
            height: 200,
            child: Lottie.asset(animationLink),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              fontFamily: 'IransansBlack',
            ),
          ),
        ],
      ),
    );
  }
}
