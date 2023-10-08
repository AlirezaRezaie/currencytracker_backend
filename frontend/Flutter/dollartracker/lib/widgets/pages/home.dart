import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dollartracker/services/get_seprate.dart';
import 'package:dollartracker/widgets/utilities/Chart/chart.dart';
import 'package:dollartracker/widgets/utilities/currency_update_table.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/utilities/network_error.dart';
import 'package:dollartracker/services/get_time_for_iran.dart';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../../services/extract_hours.dart';
import '../utilities/price_box.dart';
import '../utilities/Menu/side_menu.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:google_fonts/google_fonts.dart';
export 'package:dollartracker/services/extract_hours.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late WebSocketChannel channel;
  late BuildContext buildContext;

  // a string to store the lastNews
  String lastNews = '';

  // store the price of dollar
  int dollarPrice = 0;

  // store the server host name
  String serverHost = "";

  bool isConnecting = false;

  // store the network status from the device
  bool isNetworkConnected = true;

  // check is the data load well whene we open the page
  bool isHomeConnected = false;

  // store the data of the chart to show user
  List chartData = [];

  // store the last price table data in this list to show to the user
  List global = [];

  double lowestPriceChart = 0;
  double highestPriceChart = 0;

  // check the network status and update the status
  Future<void> checkNetworkStatus() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isNetworkConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    // get the host name
    String? host = dotenv.env['SERVER_HOST'];
    super.initState();

    buildContext = this.context;
    // get the latest news whene we open the home page
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
      channel.sink.add('SUBSCRIBE DHS');

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
            final local = jsonData['local'];
            setState(() {
              switch (local['code']) {
                case "USD":
                  // set the dollar price
                  dollarPrice = local['latests'].last['price'];

                  // clear the chart data
                  chartData = [];

                  // set the chart data

                  double lowestPrice = double
                      .infinity; // Initialize lowestPrice to positive infinity
                  double highestPrice = double
                      .negativeInfinity; // Initialize highestPrice to negative infinity
                  for (final item in local['latests']) {
                    final time = extractHour(getTimeForIran(item['posttime']));
                    final price = item['price'].toDouble();

                    // Update lowestPrice if the current price is lower
                    if (price < lowestPrice) {
                      lowestPrice = price;
                    }

                    // Update highestPrice if the current price is higher
                    if (price > highestPrice) {
                      highestPrice = price;
                    }

                    chartData.add([time, price]);
                  }
                  lowestPriceChart = lowestPrice;
                  highestPriceChart = highestPrice;
              }
              // set the list of update table data
              global = jsonData['global']['latests'].reversed.toList();
            });
            print(global);
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

  // a function to get the latest news
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
        lastNews = data['title'];
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

  // a flash message to show the user the network connection is bad and we can't connect to the server
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
                            value: dollarPrice,
                            enableSeparator: true,
                            textStyle: GoogleFonts.dosis(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          firstColor: Theme.of(context).colorScheme.primary,
                          secondColor: Theme.of(context).colorScheme.primary,
                        ),
                        PriceBox(
                          title: "🇺🇸 دلار",
                          price: AnimatedDigitWidget(
                            value: dollarPrice,
                            enableSeparator: true,
                            // recommended fonts titilliumWeb -- kanit -- dosis
                            textStyle: GoogleFonts.dosis(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          firstColor: Theme.of(context).colorScheme.primary,
                          secondColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 5),
                              child: Text(
                                "نمودار معاملات امروز",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontFamily: "IransansBlack",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 200,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Chart(
                                  data: chartData,
                                  minY: lowestPriceChart,
                                  maxY: highestPriceChart,
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
                                lastNews,
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
                          Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Text(
                              '📰',
                              style: TextStyle(fontSize: 25),
                            ),
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
                            padding: EdgeInsets.only(bottom: 1, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "جدید ترین آپدیت های قیمت",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
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
                                if (global[index]['rateofchange'] == null ||
                                    global[index]['price'].runtimeType ==
                                        String)
                                  return SizedBox(
                                    height: 0,
                                  );
                                return CurrencyUpdateTable(
                                  name: global[index]['persian_name'],
                                  priceColor:
                                      global[index]['rateofchange'] != null
                                          ? global[index]['rateofchange'] > 0
                                              ? Colors.greenAccent
                                              : Colors.redAccent
                                          : Colors.white,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  price: separateNumberWithCommas(
                                      global[index]['price']),
                                  time:
                                      getTimeForIran(global[index]['posttime']),
                                  imageLink: global[index]['image_link'],
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
