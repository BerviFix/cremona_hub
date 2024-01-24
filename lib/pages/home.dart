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

  @override
  void initState() {
    super.initState();
    newsListFuture = listNews.getNewsList();
    categoriesListFuture = listCategories.getCategoriesList();
    weatherFuture = weather.getWeather();
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
      ),
      drawer: DrawerCat(
        categoriesListFuture: categoriesListFuture,
      ),
      body: Stack(
        children: [
          Weather(
            weatherFuture: weatherFuture,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshNewsList,
              child: FutureBuilder(
                future: newsListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.55,
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 130, 16, 16),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return NewsTile(
                          title: snapshot.data![index].title,
                          image: snapshot.data![index].image ?? '',
                          date: snapshot.data![index].date,
                          id: snapshot.data![index].id,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
