import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:cremona_hub/models/news_model.dart';

class CategoryArchiveRepository {
  Future<List<NewsModel>> getNewsArchive(int categoryID) async {
    final random = Random();
    final int randomNumber = random.nextInt(50) + 50;

    final response = await http.get(Uri.parse(
        'https://www.cremonaoggi.it/wp-json/wp/v2/posts?categories=$categoryID&per_page=$randomNumber'));

    final jsonData = jsonDecode(response.body);

    List<NewsModel> newsList =
        (jsonData as List).map((json) => NewsModel.fromJson(json)).toList();

    return newsList;
  }
}
