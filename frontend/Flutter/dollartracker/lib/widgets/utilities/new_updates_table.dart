import 'package:flutter/material.dart';

class NewUpdatesTable extends StatelessWidget {
  final String title;
  final String subtitle;
  final double persent;
  final String imageLink;

  const NewUpdatesTable({
    super.key,
    required this.title,
    required this.subtitle,
    required this.persent,
    required this.imageLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 7),
            )
          ],
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(right: 10, left: 10, top: 6, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$persent %",
                style: TextStyle(color: Colors.greenAccent),
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(97, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imageLink),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
