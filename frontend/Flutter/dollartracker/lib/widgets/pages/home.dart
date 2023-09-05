import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert'; // Import this package for jsonDecode

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late WebSocketChannel channel;
  String receivedData = '';
  bool isConnecting = false;
  String errorMessage = '';

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
    return Padding(
      padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  // here you can add functionality for the icon
                  onPressed: () {},
                  icon: Icon(
                    BootstrapIcons.list,
                    color: Colors.white,
                    size: 30,
                  )),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Text(
                          // the name of the user
                          "سلام بچه گل",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'IransansBlack'),
                        ),
                      ),
                      Text(
                        "خوش آمدی",
                        style: TextStyle(
                          color: Color.fromARGB(219, 255, 255, 255),
                          fontSize: 10,
                          fontFamily: 'IransansBlack',
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: CircleAvatar(
                      radius: 27.0,
                      // user profile
                      backgroundImage: NetworkImage(
                          'http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRlinunhNqurn4hIJDnknNiB1DJ27akcg37NDplUl4ZtVBj3VOP6wkBEdjkZ24LFt4k4bq9k07Q6eTyMsDGECtNc3XZNCjtNwm51WD43CI'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "ارز های محبوب",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  fontFamily: 'IransansBlack',
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 245, 78, 97),
                      Color.fromARGB(255, 117, 9, 22)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    EdgeInsets.only(top: 35, right: 45, bottom: 35, left: 45),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the content vertically
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    Text(
                      "قیمت مستقیم صرافی",
                      style: TextStyle(
                        color: Color.fromARGB(173, 255, 255, 255),
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        fontFamily: 'Iransans',
                      ),
                    ),
                    Text(
                      "🇪🇺 یورو",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'IransansBlack'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            "500/000",
                            style: GoogleFonts.aladin(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromARGB(255, 112, 151, 252),
                      Color.fromARGB(255, 9, 35, 101)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                padding:
                    EdgeInsets.only(top: 35, right: 45, bottom: 35, left: 45),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the content vertically
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Center the content horizontally
                  children: [
                    Text(
                      "قیمت مستقیم صرافی",
                      style: TextStyle(
                        color: Color.fromARGB(173, 255, 255, 255),
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                        fontFamily: 'Iransans',
                      ),
                    ),
                    Text(
                      "🇺🇸 دلار",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          fontFamily: 'IransansBlack'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            "500/000",
                            style: GoogleFonts.aladin(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
