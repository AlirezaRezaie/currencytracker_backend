import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    String host = dotenv.env['SERVER_HOST'] ?? 'localhost';
    super.initState();
    // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
    _connectToWebSocket("$host/live/dollar_tehran3bze");

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 500), // Change the duration as needed
    );

    // Initialize the animation
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
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
          _controller.reset();
          _controller.forward();
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
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }

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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Text(
                        receivedData,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 61, 57, 57),
                          fontWeight: FontWeight.bold,
                          fontSize: 60 +
                              (_animation.value *
                                  20), // Change the font size range as needed
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              Text(
                isConnecting ? "connecting.." : "connected",
                style: TextStyle(color: Colors.amber),
              )
            ],
          ),
        ),
      ],
    );
  }
}
