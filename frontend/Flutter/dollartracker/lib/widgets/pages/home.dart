import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late WebSocketChannel channel;
  String receivedData = '';

  @override
  void initState() {
    super.initState();
    // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
    channel = IOWebSocketChannel.connect('ws://192.168.1.6:8000/live');
    channel.stream.listen((data) {
      setState(() {
        receivedData = data;
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
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
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  Text(
                    receivedData,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
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
