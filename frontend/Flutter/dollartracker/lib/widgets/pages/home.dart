import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/widgets/utilities/Chart/chart.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/network_error.dart';
import 'package:dollartracker/services/get_time_for_iran';
import 'package:dollartracker/widgets/utilities/currency_table.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:http/http.dart' as http;
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

  String lastNew = '';
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

  List global = [];

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
    getNews(host);
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
          if (jsonData.containsKey('local')) {
            // Update the animation when the price changes
            setState(() {
              receivedData = jsonData['local']['latests'].last['price'];
              global = jsonData['global']['latests'].reversed.toList();
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

  Future<void> getNews(host) async {
    final response = await http.get(
      Uri.parse(
        'http://$host/news/get_news/latest',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      // You can now work with the data
      setState(() {
        // set the list of news
        lastNew = data['title'];
        // reverse the list to sort the news currectly
      });
    } else {
      // If the server did not return a 200 OK response
      print("Error");
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
        iconColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Color.fromARGB(255, 15, 15, 16),
        indicatorColor: Color.fromARGB(255, 255, 204, 0),
        icon: Icon(BootstrapIcons.exclamation_circle),
        title: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            'هشدار',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
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
              color: Theme.of(context).colorScheme.onPrimary,
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isHomeConnected
          ? Column(
              children: [
                Column(
                  children: [
                    Header(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      color: Theme.of(context).colorScheme.onBackground,
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
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          firstColor: Theme.of(context).colorScheme.primary,
                          secondColor: Theme.of(context).colorScheme.primary,
                        ),
                        PriceBox(
                          title: "🇺🇸 دلار",
                          price: AnimatedDigitWidget(
                            value: receivedData,
                            enableSeparator: true,
                            textStyle: GoogleFonts.aladin(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                          firstColor: Theme.of(context).colorScheme.primary,
                          secondColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                "قیمت دلار امروز",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                lastNew,
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontFamily: "IransansBlack",
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Text(
                            '📰',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2, bottom: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    fontFamily: 'IransansBlack',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(25),
                              physics: BouncingScrollPhysics(),
                              itemCount: global.length,
                              itemBuilder: (context, index) {
                                return CurrencyTable(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  price: global[index]['price'],
                                  persentColor:
                                      global[index]['rateofchange'] != null
                                          ? global[index]['rateofchange'] > 0
                                              ? Colors.greenAccent
                                              : Colors.redAccent
                                          : Colors.white,
                                  time:
                                      getTimeForIran(global[index]['posttime']),
                                  imageLink:
                                      global[index]['rateofchange'] != null
                                          ? global[index]['rateofchange'] > 0
                                              ? 'assets/upArrow.png'
                                              : 'assets/downArrrow.png'
                                          : 'assets/line.png',
                                  persent: global[index]['rateofchange'] == null
                                      ? 0
                                      : global[index]['rateofchange'],
                                  volatility:
                                      global[index]['rateofchange'] != null
                                          ? global[index]['rateofchange'] > 0
                                              ? 'صعودی'
                                              : 'نزولی'
                                          : 'نامشخص',
                                );
                              },
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
