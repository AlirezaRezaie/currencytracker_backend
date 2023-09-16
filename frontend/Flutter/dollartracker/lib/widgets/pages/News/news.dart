import 'dart:convert';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:dollartracker/widgets/pages/News/news_post.dart';
import 'package:dollartracker/widgets/utilities/Skeleton/news_card_skeleton.dart';
import 'package:dollartracker/widgets/utilities/header.dart';
import 'package:dollartracker/widgets/pages/News/news_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../utilities/Menu/side_menu.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  // set the list of news to map and display to the user
  List newsList = [];
  bool isLoading = true;
  Future<void> fetchData() async {
    String? host = dotenv.env['SERVER_HOST'];

    final response = await http.get(
      Uri.parse(
        'http://$host/get_news',
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
        newsList = data.cast();
        // reverse the list to sort the news currectly
        newsList = newsList.reversed.toList();
        isLoading = false;
      });
      print(newsList);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('faild to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideMenu(),
      backgroundColor: Color.fromARGB(255, 15, 15, 16),
      body: Column(
        children: [
          Header(
            profileImage:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg/220px-Robert_Downey_Jr_2014_Comic_Con_%28cropped%29.jpg",
            color: Colors.white,
            backgroundColor: const Color.fromARGB(0, 255, 255, 255),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 15,
              left: 15,
              bottom: 20,
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    // If the search text is empty, return the original list
                    // No need to filter, just reset to the original list
                    fetchData();
                  } else {
                    // Filter the list based on the search text
                    newsList = newsList.where((news) {
                      final title = news["title"].toLowerCase();
                      return title.contains(value.toLowerCase());
                    }).toList();
                  }
                });
              },
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  BootstrapIcons.search,
                ),
                prefixIconColor: const Color.fromARGB(150, 255, 255, 255),
                filled: true,
                fillColor: Color.fromARGB(255, 27, 28, 34),
                hintTextDirection: TextDirection.rtl,
                hintText: "جستجوری خبر ...",
                hintStyle: TextStyle(
                  color: Color.fromARGB(150, 255, 255, 255),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          isLoading
              ? Expanded(
                  child: RefreshIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Color.fromARGB(255, 27, 28, 34),
                    onRefresh: () async {
                      await fetchData();
                      setState(() {});
                    },
                    child: ListView.separated(
                      itemBuilder: (context, index) => NewsCardSkeleton(),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemCount: 6,
                    ),
                  ),
                )
              : Expanded(
                  child: RefreshIndicator(
                    color: Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Color.fromARGB(255, 27, 28, 34),
                    onRefresh: () async {
                      await fetchData();
                      setState(() {});
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return NewsCard(
                          thumbnail: newsList[index]['image_link'],
                          title: newsList[index]['title'],
                          topic: newsList[index]['topic'],
                          time: newsList[index]['created_at'],
                          onPress: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsPostPage(
                                image: newsList[index]['image_link'],
                                title: newsList[index]['title'],
                                content: newsList[index]['description'],
                                readTime: newsList[index]['time_to_read'],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
