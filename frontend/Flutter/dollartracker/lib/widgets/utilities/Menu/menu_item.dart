import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String routName;
  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.routName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, "/$routName"),
        child: Container(
          width: 250,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: color,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'IransansBlack',
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                icon,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
