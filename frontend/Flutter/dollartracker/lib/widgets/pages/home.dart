import 'package:dollartracker/widgets/utilities/Chart/chart.dart';
import 'package:dollartracker/widgets/utilities/new_updates_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'dart:convert';
import '../utilities/price_box.dart'; // Import this package for jsonDecode

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late WebSocketChannel channel;
  String receivedData = '';
  double changeRate = 0;
  bool isConnecting = false;
  String errorMessage = '';
  List chartData = [
    30500.0,
    40500.0,
    50500.0,
    55500.0,
  ];

  @override
  void initState() {
    // String host = dotenv.env['SERVER_HOST'] ?? 'localhost';
    super.initState();
    // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
    _connectToWebSocket("ws://10.0.2.2:5000/live/nerkhedollarr");
  }

  void _connectToWebSocket(String host) async {
    setState(() {
      isConnecting = true;
      errorMessage = '';
    });

    channel = IOWebSocketChannel.connect(host);
    channel.stream.listen(
      (data) {
        print(data);
        // Parse the received data as JSON
        Map<String, dynamic> jsonData = jsonDecode(data);
        // Check if the 'price' field exists and is a numeric value
        if (jsonData.containsKey('price')) {
          // Update the animation when the price changes
          print(jsonData);
          setState(() {
            receivedData =
                jsonData['price']; // Format the price to two decimal places
          });
        }
      },
      onDone: () {
        print("WebSocket disconnected");
        _reconnectToWebSocket(host);
      },
      onError: (error) {
        print("WebSocket error: $error");
        setState(() {
          errorMessage = "WebSocket error: $error";
        });
        _reconnectToWebSocket(host);
      },
    );

    setState(() {
      isConnecting = false;
    });
  }

  void _reconnectToWebSocket(String host) {
    if (!isConnecting) {
      Future.delayed(Duration(seconds: 5), () {
        _connectToWebSocket(host);
      });
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // add some padding to make space
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    // user profile
                    backgroundImage: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chris_Hemsworth_by_Gage_Skidmore_2_%28cropped%29.jpg/220px-Chris_Hemsworth_by_Gage_Skidmore_2_%28cropped%29.jpg'),
                  ),
                  Text(
                    "Currency Wave",
                    style: GoogleFonts.aladin(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 25,
                    ),
                  ),
                  IconButton(
                    // here you can add functionality for the icon
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: Icon(
                      BootstrapIcons.list,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PriceBox(
                    title: "🇪🇺 یورو",
                    price: "57/000",
                    firstColor: Color.fromARGB(255, 60, 80, 250),
                    secondColor: Color.fromARGB(255, 60, 78, 246),
                  ),
                  PriceBox(
                    title: "🇺🇸 دلار",
                    price: "50/000",
                    firstColor: Color.fromARGB(255, 60, 80, 250),
                    secondColor: Color.fromARGB(255, 60, 78, 246),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 27, 28, 34),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text(
                        "قیمت دلار امروز",
                        style: TextStyle(
                            color: Colors.white, fontFamily: "IransansBlack"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: 15,
                        left: 15,
                        top: 10,
                        bottom: 20,
                      ),
                      child: Container(
                        height: 150,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Chart(data: chartData),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 60, 80, 250),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            child: Container(
              color: Color.fromARGB(255, 27, 28, 34),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 196, 209, 225),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 12.0),
                      height: 4.0,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "جدید ترین آپدیت های قیمت",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            fontFamily: 'IransansBlack',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(25),
                      children: const [
                        NewUpdatesTable(
                          title: "دلار",
                          subtitle: "صعودی",
                          imageLink: "",
                          persent: 45,
                        ),
                        NewUpdatesTable(
                          title: "دلار",
                          subtitle: "صعودی",
                          imageLink: "",
                          persent: 65,
                        ),
                        NewUpdatesTable(
                          title: "دلار",
                          subtitle: "صعودی",
                          imageLink: "",
                          persent: 0.25,
                        ),
                        NewUpdatesTable(
                          title: "دلار",
                          subtitle: "صعودی",
                          imageLink: "",
                          persent: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
