import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 151, 230),
              borderRadius: BorderRadius.circular(10)
            ),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  Text(
                    "The Price of Dollar",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          child: const Column(
            children: [
              Text(
                "Hell",
                style: TextStyle(color: Colors.amber),
              )
            ],
          ),
        ),
      ],
    );
  }
}
