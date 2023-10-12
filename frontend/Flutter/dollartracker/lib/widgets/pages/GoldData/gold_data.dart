import 'package:dollartracker/widgets/pages/GoldData/gold_data_table.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../utilities/Menu/side_menu.dart';
import '../../utilities/currency_selector.dart';
import '../../utilities/header.dart';

class GoldData extends StatefulWidget {
  const GoldData({super.key});

  @override
  State<GoldData> createState() => _GoldDataState();
}

class _GoldDataState extends State<GoldData> {
  bool isLoading = true;
  bool isFetchsuccess = true;

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
                      "56,450",
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
                      listOfCurrency: [
                        'USD',
                        'btn',
                        'fsdd',
                      ],
                      width: 320,
                      height: 60,
                      getCurrency: (currency) {},
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
                                  itemCount: 6,
                                  itemBuilder: (context, index) {
                                    return GoldDataTable(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      imageLink:
                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Cillian_Murphy-2014.jpg/220px-Cillian_Murphy-2014.jpg",
                                      name: "alireza",
                                      presentColor: Colors.green,
                                      price: 45000,
                                      priceColor: Colors.white,
                                      time: "22:23",
                                      rateOfChange: 45,
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
                        width: 450,
                        height: 350,
                        child: Lottie.asset("assets/Error.json"),
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
