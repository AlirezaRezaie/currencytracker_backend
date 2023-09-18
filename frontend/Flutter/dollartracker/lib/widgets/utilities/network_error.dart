import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NetworkError extends StatelessWidget {
  final VoidCallback onPress;

  const NetworkError({
    super.key,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 250,
          height: 200,
          child: Lottie.asset("assets/NetworkError.json"),
        ),
        Text(
          "مشکل در اتصال به سرور",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            fontFamily: 'IransansBlack',
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(
          "از اتصال اینترنت خود اطمینان حاصل کنید و دوباره امتحان کنید",
          style: TextStyle(
            color: const Color.fromARGB(200, 255, 255, 255),
            fontWeight: FontWeight.w400,
            fontSize: 11,
            fontFamily: 'IransansBlack',
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: ElevatedButton(
            onPressed: onPress,
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
                  borderRadius: BorderRadius.circular(8), // Border radius
                ),
              ),
            ),
            child: Text(
              "تلاش مجدد",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                fontFamily: 'IransansBlack',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
