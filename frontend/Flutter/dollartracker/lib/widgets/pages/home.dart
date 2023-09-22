import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/widgets/utilities/Chart/chart.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/network_error.dart';
import 'package:dollartracker/widgets/utilities/new_updates_table.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../utilities/price_box.dart';
import '../utilities/Menu/side_menu.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late WebSocketChannel channel;
  late BuildContext buildContext;

  int receivedData = 0;
  double changeRate = 0;
  int value = 9999;
  String serverHost = "";
  bool isConnecting = false;
  bool isNetworkConnected = true;
  bool isHomeConnected = false;
  List chartData = [
    30500.0,
    40500.0,
    50500.0,
    55500.0,
  ];

  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isNetworkConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    String? host = dotenv.env['SERVER_HOST'];
    super.initState();

    buildContext = this.context;

    // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
    serverHost = "ws://$host/api/";
    _connectToWebSocket(serverHost);
  }

  void _connectToWebSocket(String host) async {
    bool called = false;
    if (!isConnecting) {
      isConnecting = true;

      channel = IOWebSocketChannel.connect(host);
      channel.sink.add('SUBSCRIBE USD');

      channel.stream.listen(
        (data) {
          isConnecting = false;

          if (data == "CONNECTED") {
            setState(() {
              isHomeConnected = true;
            });
          }
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
          print("Server closed the connection");
          isConnecting = false;
          if (!called) {
            _reconnectToWebSocket(serverHost);
            called = true;
          }
        },
        onError: (error) {
          print("WebSocket error");
          isConnecting = false;
          if (!called) {
            _reconnectToWebSocket(serverHost);
            called = true;
          }
        },
      );
    } else {
      print("already calling the connection function bro");
    }
  }

  void _reconnectToWebSocket(String host) {
    print("reconnecting.....");
    showFlash();
    Future.delayed(Duration(seconds: 5), () {
      _connectToWebSocket(host);
    });
  }

  void showFlash() {
    print("show flash");

    buildContext.showFlash<bool>(
      duration: const Duration(seconds: 5),
      builder: (context, controller) => FlashBar(
        controller: controller,
        behavior: FlashBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: Color.fromARGB(255, 15, 15, 16),
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        margin: const EdgeInsets.all(32.0),
        clipBehavior: Clip.antiAlias,
        iconColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 15, 15, 16),
        indicatorColor: Color.fromARGB(255, 255, 204, 0),
        icon: Icon(BootstrapIcons.exclamation_circle),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'هشدار',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'IransansBlack',
            ),
          ),
        ),
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'بنظر میرسد اتصال شما دچار مشکل شده است، در حال اتصال مجدد...',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 11,
              fontFamily: 'IransansBlack',
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
// check the internet connection every 1 second
    //buildContext = context;
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: isHomeConnected
          ? Column(
              children: [
                Column(
                  children: [
                    Header(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      color: Colors.white,
                      profileImage:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        PriceBox(
                          title: "🇪🇺 یورو",
                          price: AnimatedDigitWidget(
                            value: receivedData,
                            enableSeparator: true,
                            textStyle: GoogleFonts.aladin(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          firstColor: Color.fromARGB(255, 60, 80, 250),
                          secondColor: Color.fromARGB(255, 60, 78, 246),
                        ),
                        PriceBox(
                          title: "🇺🇸 دلار",
                          price: AnimatedDigitWidget(
                            value: receivedData,
                            enableSeparator: true,
                            textStyle: GoogleFonts.aladin(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          firstColor: Color.fromARGB(255, 60, 80, 250),
                          secondColor: Color.fromARGB(255, 60, 78, 246),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
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
                                  color: Colors.white,
                                  fontFamily: "IransansBlack",
                                ),
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
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    width: 360,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromARGB(255, 60, 80, 250),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "قیمت دلار امروز",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "IransansBlack",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40)),
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
                              physics: BouncingScrollPhysics(),
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
            )
          // a loading screen whene the main data is on loading
          : isNetworkConnected
              ? Center(
                  child: Container(
                    width: 400,
                    height: 300,
                    child: Lottie.asset("assets/Loading.json"),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: NetworkError(
                        onPress: () {
                          // recheck the network status
                          checkNetworkStatus();
                        },
                      ),
                    )
                  ],
                ),
    );
  }
}
