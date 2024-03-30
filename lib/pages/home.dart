import 'package:cremona_hub/components/ad_add.dart';
import 'package:cremona_hub/components/weather.dart';
import 'package:cremona_hub/models/weather_model.dart';
import 'package:cremona_hub/repositories/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:cremona_hub/components/drawer_cat.dart';
import 'package:cremona_hub/components/news_tile.dart';
import 'package:cremona_hub/models/category_model.dart';
import 'package:cremona_hub/models/news_model.dart';
import 'package:cremona_hub/repositories/categories_repository.dart';
import 'package:cremona_hub/repositories/news_list_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsListRepository listNews = NewsListRepository();
  late Future<List<NewsModel>> newsListFuture;
  final CategoriesRepository listCategories = CategoriesRepository();
  late Future<List<CategoryModel>> categoriesListFuture;
  final WeatherRepository weather = WeatherRepository();
  late Future<WeatherModel> weatherFuture;
  ConnectivityResult _connectivityResult =
      ConnectivityResult.none; //  Keep track of connectivity

  @override
  void initState() {
    super.initState();
    newsListFuture = listNews.getNewsList();
    categoriesListFuture = listCategories.getCategoriesList();
    weatherFuture = weather.getWeather();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  // Function to check network connectivity
  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      _connectivityResult = result;
    });
  }

  Future<void> _refreshNewsList() async {
    setState(() {
      newsListFuture = listNews.getNewsList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset('assets/cremonahub4.png', height: 50),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.lime,
          scrolledUnderElevation: 10,
          centerTitle: true,
        ),
        drawer: _connectivityResult != ConnectivityResult.none
            ? DrawerCat(
                categoriesListFuture: categoriesListFuture,
              )
            : null,
        body: Stack(
          children: [
            _connectivityResult != ConnectivityResult.none
                ? Center(
                    child: RefreshIndicator(
                      onRefresh: _refreshNewsList,
                      child: SizedBox(
                        width: 450,
                        child: ListView(
                          children: [
                            Weather(
                              weatherFuture: weatherFuture,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: FutureBuilder(
                                future: newsListFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height -
                                              216,
                                      alignment: Alignment.center,
                                      child: const CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error: ${snapshot.error}'),
                                    );
                                  } else {
                                    final dateFormat = DateFormat(
                                        'dd MMM yyyy HH:mm', 'it_IT');
                                    final sortedNewsList = snapshot.data!
                                      ..sort((a, b) => dateFormat
                                          .parse(b.date)
                                          .compareTo(dateFormat.parse(a.date)));
                                    List<Widget> finalList = [];
                                    for (var index = 0;
                                        index < sortedNewsList.length;
                                        index++) {
                                      final news = sortedNewsList[index];
                                      finalList.add(
                                        IntrinsicHeight(
                                          child: NewsTile(
                                            title: news.title,
                                            image: news.image ?? '',
                                            date: news.date,
                                            id: news.id,
                                            source: news.source,
                                          ),
                                        ),
                                      );
                                      if ((index + 1) % 2 == 0) {
                                        finalList.add(AddAd());
                                      }
                                    }

                                    return Wrap(
                                      children: finalList,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 50,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 8), //  Add SizedBox
                              const Text(
                                'Nessuna connesione a internet! Controlla che il gatto non stia giocando con il cavo di rete.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Lottie.asset(
                                'assets/no-cat-connection.json',
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
