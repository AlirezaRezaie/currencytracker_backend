import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late WebSocketChannel channel;
  String receivedData = '';
  bool isConnecting = false;
  String errorMessage = '';

  @override
  void initState() {
    String host = dotenv.env['SERVER_HOST'] ?? 'localhost';
    super.initState();
    // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
    _connectToWebSocket(host);
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
        setState(() {
          receivedData = data;
        });
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
                  Text(
                    receivedData,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isConnecting
                      ? Text(
                          "Connecting...",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : SizedBox(),
                  errorMessage.isNotEmpty
                      ? Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : SizedBox(),
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
