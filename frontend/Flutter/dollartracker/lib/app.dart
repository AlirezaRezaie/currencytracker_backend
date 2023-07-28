import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import './widgets/pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 252, 203, 6),
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      backgroundColor: Color.fromARGB(148, 23, 4, 231),
      body: const Home(),
      bottomNavigationBar: CurvedNavigationBar(
        color: const Color.fromARGB(255, 223, 249, 251),
        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
        items: const [
          Icon(Icons.home, size: 30),
          Icon(Icons.add, size: 30),
          Icon(Icons.menu_outlined, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
        },
      ),
    );
  }
}
