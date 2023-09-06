import 'package:dollartracker/widgets/utilities/new_updates_table.dart';
import 'package:flutter/material.dart';
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
                          'http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRt7JLIi2G3ioqZgtLjL_wIwxiBKZ0R03ebcbbHFiIrAlFxMqTl-yCgWRT1ILTGA_ObuRm-N4Pk1hb2q8oH-qbaO1mIC2-4ng8rR0pmQVo'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "ارز های محبوب",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        fontFamily: 'IransansBlack',
                      ),
                    ),
                    Text(
                      "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم",
                      style: TextStyle(
                        color: const Color.fromARGB(190, 255, 255, 255),
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        fontFamily: 'Iransans',
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PriceBox(
                title: "🇪🇺 یورو",
                price: "500/000",
                firstColor: Color.fromARGB(255, 245, 78, 97),
                secondColor: Color.fromARGB(255, 117, 9, 22),
              ),
              PriceBox(
                title: "🇺🇸 دلار",
                price: "500/000",
                firstColor: Color.fromARGB(255, 112, 151, 252),
                secondColor: Color.fromARGB(255, 9, 35, 101),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
              Padding(
                padding: EdgeInsets.only(left: 5),
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 196, 209, 225),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 12.0),
                      height: 4.0,
                      width: MediaQuery.of(context).size.width * 0.2,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, right: 40, left: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Menu",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Icon(
                            Icons.more_horiz_outlined,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(40),
                        children: const [NewUpdatesTable()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
