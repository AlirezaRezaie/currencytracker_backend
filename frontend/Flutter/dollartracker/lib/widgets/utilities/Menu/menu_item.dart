import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color background_color;
  final Color color;
  final String routName;
  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.background_color,
    required this.color,
    required this.routName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, "/$routName"),
        child: Container(
          width: 250,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: background_color,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontFamily: 'IransansBlack',
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
