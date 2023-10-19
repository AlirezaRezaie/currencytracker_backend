import 'dart:convert';
import 'package:dollartracker/widgets/pages/GoldData/gold_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../utilities/Menu/side_menu.dart';
import '../../utilities/currency_selector.dart';
import '../../utilities/header.dart';
import 'package:http/http.dart' as http;

class GoldData extends StatefulWidget {
  const GoldData({super.key});

  @override
  State<GoldData> createState() => _GoldDataState();
}

class _GoldDataState extends State<GoldData> {
  bool isLoading = true;
  bool isFetchsuccess = true;

  late WebSocketChannel channel;

  // store the server host name
  String serverHost = "";

  // save the latest price to show to the user
  String latestPrice = '';

  // a list to store the fetched data
  List global = [];

  // save the list of the gold data
  List goldList = [];

  String currentCurrency = '';

  List<String> goldNameList = [];

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
        'http://$host/counter/get_supported?q=GOLD',
      ),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    // if the fetch is successful
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      String responseBody = utf8.decode(response.bodyBytes);
      final data = json.decode(responseBody);
      print(data);
      goldList = data;

      for (int i = 0; i < goldList.length; i++) {
        goldNameList.add(goldList[i]["name"]);
      }
      setState(() {
        currentCurrency = data[0]["code"];
      });
      print(goldNameList);
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
    channel.sink.add('SUBSCRIBE TGJU $currentCurrency');

    channel.stream.listen(
      (data) {
        try {
          // Parse the received data as JSON
          Map<String, dynamic> jsonData = jsonDecode(data);
          // Check if the 'price' field exists and is a numeric value
          for (var entry in jsonData.entries) {
            String key = entry.key;
            List<dynamic> value = entry.value.reversed.toList();

            setState(() {
              isLoading = false;
              latestPrice = value[0].split("|")[1];
            });
            final local = value;
            setState(() {
              global = [];
            });
            local.forEach((item) {
              Map<String, String> data = {
                "price": item.split('|')[1],
                "rate_of_change": item.split('|')[6],
                "change": item.split('|')[7],
                "time": item.split('|')[8],
              };
              setState(() {
                global.add(data);
              });
            });
            setState(() {
              isLoading = false;
              isFetchsuccess = true;
            });
            print("Key: $key, Value: $value");
          }
        } catch (e) {
          print(e);
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
                        child: Lottie.asset("assets/CoinLoading.json"),
                      ),
                      Text(
                        "... در حال بارگیری اطلاعات",
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
                      latestPrice,
                      style: GoogleFonts.monoton(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      "قیمت طلا در حال حاظر",
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
                      listOfCurrency: goldNameList,
                      width: 320,
                      height: 60,
                      getCurrency: (currency) {
                        setState(() {
                          currentCurrency = goldList
                              .where((element) => element['name'] == currency)
                              .toList()[0]['code'];
                        });
                        _connectToWebSocket(serverHost);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        "انتخواب مورد دلخواه برای دریافت قیمت آن به تومان",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontFamily: "IransansBlack",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                                      "تغییرات قیمت طلا",
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
                                    return GoldDataTable(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      imageLink:
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg",
                                      name: "alireza",
                                      presentColor:
                                          global[index]['change'] == "low"
                                              ? Colors.red
                                              : Colors.green,
                                      price: global[index]["price"],
                                      priceColor: Colors.white,
                                      time: global[index]["time"],
                                      rateOfChange: double.parse(
                                          global[index]["rate_of_change"]),
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
                              width: 450,
                              height: 350,
                              child: Lottie.asset("assets/Error.json"),
                            ),
                            Text(
                              "خطا در برقرای ارتباط با سرور",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
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
                                      borderRadius: BorderRadius.circular(
                                          8), // Border radius
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "تلاش مجدد",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    fontFamily: 'IransansBlack',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
