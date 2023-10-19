import 'dart:convert';
import 'package:dollartracker/services/second_to_time.dart';
import 'package:dollartracker/widgets/pages/CryptoCurrency/crypto_currency_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../services/get_time_for_iran.dart';
import '../../utilities/Menu/side_menu.dart';
import '../../utilities/currency_selector.dart';
import '../../utilities/header.dart';
import 'package:http/http.dart' as http;

class CryptoCurrency extends StatefulWidget {
  const CryptoCurrency({Key? key}) : super(key: key);

  @override
  State<CryptoCurrency> createState() => _CryptoCurrencyState();
}

class _CryptoCurrencyState extends State<CryptoCurrency> {
  List<bool> _selection = [false, false, true];
  late WebSocketChannel channel;

  // store the server host name
  String serverHost = "";

  // save the latest price to show to the user
  String latestPrice = '';

  // a list to store the fetched data
  List global = [];

  // save the loading status
  bool isLoading = false;

  // save the status of data that fetched
  bool isFetchsuccess = true;

  List currencyList = [];

  String currentCurrency = '';

  List<String> currencyNameList = [];

  @override
  void initState() {
    super.initState();

    // get the host name
    String? host = dotenv.env['SERVER_HOST'];

    getGoldList(host);
  }

  Future<void> getGoldList(String? host) async {
    isLoading = true;
    final response = await http.get(
      Uri.parse(
        'http://$host/counter/get_supported?q=CRYPTO',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    // if the fetch is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      print(data);
      currencyList = data;

      for (int i = 0; i < currencyList.length; i++) {
        currencyNameList.add(currencyList[i]["name"]);
      }
      setState(() {
        currentCurrency = data[0]["code"];
      });
      print(currencyNameList);
      // Replace 'ws://your_websocket_url' with your actual WebSocket server URL.
      serverHost = "ws://$host/api/";
      _connectToWebSocket(serverHost);
      // You can now work with the data
    } else {
      // If the server did not return a 200 OK response
      print("Error");
    }
  }

  void _connectToWebSocket(String host) async {
    isLoading = true;
    channel = IOWebSocketChannel.connect(host);
    channel.sink.add('SUBSCRIBE BTC');

    channel.stream.listen(
      (data) {
        // Parse the received data as JSON
        Map<String, dynamic> jsonData = jsonDecode(data);
        // Check if the 'price' field exists and is a numeric value
        if (jsonData.containsKey('local')) {
          final local = jsonData['local'];

          setState(() {
            latestPrice = local['latests'].last['price'].toString();
            global = jsonData['global']['latests'].reversed.toList();
            isLoading = false;
            isFetchsuccess = true;
          });
        }
      },
      onDone: () {
        print("Server closed the connection");
        _reconnectToWebSocket(serverHost);
      },
      onError: (error) {
        print("WebSocket error");
        _reconnectToWebSocket(serverHost);
      },
    );
  }

  void _reconnectToWebSocket(String host) async {
    print("reconnecting.....");
    await Future.delayed(Duration(seconds: 5), () {
      _connectToWebSocket(host);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: isLoading
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Header(
                  backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                  color: Theme.of(context).colorScheme.onBackground,
                  profileImage:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
                ),
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Container(
                        width: 500,
                        height: 400,
                        child: Lottie.asset("assets/bitcoinLoading.json"),
                      ),
                      Text(
                        "... در حال اتصال به سرور ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'IransansBlack',
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          : isFetchsuccess
              ? Column(
                  children: [
                    Header(
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      color: Theme.of(context).colorScheme.onBackground,
                      profileImage:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg',
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "\$ $latestPrice",
                      style: GoogleFonts.monoton(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      "قیمت بیتکوین در حال حاظر",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: "IransansBlack",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CurrencySelector(
                      listOfCurrency: currencyNameList,
                      width: 320,
                      height: 60,
                      getCurrency: (currency) {},
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ToggleButtons(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "یورو",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "دلار",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            "ریال",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ],
                      selectedColor: Theme.of(context).colorScheme.onPrimary,
                      fillColor: Theme.of(context).colorScheme.primary,
                      splashColor: Theme.of(context).colorScheme.primary,
                      isSelected: _selection,
                      onPressed: (int newValue) {
                        setState(() {
                          for (int index = 0;
                              index < _selection.length;
                              index++) {
                            if (index == newValue) {
                              _selection[index] = true;
                            } else {
                              _selection[index] = false;
                            }
                          }
                        });
                      },
                      color: Theme.of(context).colorScheme.onBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        child: Container(
                          color: Theme.of(context).colorScheme.tertiary,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 2, bottom: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(top: 12.0),
                                  height: 4.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10, top: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "تغییرات قیمت بیتکوین",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
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
                                    return CryptoCurrencyTable(
                                      presentColor: global[index]
                                                  ['rateofchange'] !=
                                              null
                                          ? global[index]['rateofchange'] > 0
                                              ? Colors.greenAccent
                                              : Colors.redAccent
                                          : Colors.white,
                                      rateOfChange:
                                          global[index]['rateofchange'] == null
                                              ? 0
                                              : global[index]['rateofchange'],
                                      price: global[index]['price'],
                                      time: getTimeForIran(SecondToTime(
                                          global[index]['posttime'])),
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      priceColor: Colors.white,
                                      imageLink:
                                          "https://cryptologos.cc/logos/bitcoin-btc-logo.png",
                                      name: global[index]['code'],
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
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350,
                        height: 300,
                        child: Lottie.asset("assets/Error2.json"),
                      ),
                      Text(
                        "خطا در برقرای ارتباط با سرور",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: 'IransansBlack',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                              EdgeInsets.only(
                                right: 20,
                                left: 20,
                                top: 10,
                                bottom: 10,
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Border radius
                              ),
                            ),
                          ),
                          child: Text(
                            "تلاش مجدد",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: 'IransansBlack',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
