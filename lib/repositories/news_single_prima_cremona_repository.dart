import 'package:cremona_hub/models/single_news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsSinglePrimaCremonaRepository {
  Future<SingleNewsModel> getSingleNews(int newsID) async {
    final response = await http
        .get(Uri.parse('https://primacremona.it/wp-json/wp/v2/posts/$newsID'));

    final jsonData = jsonDecode(response.body);

    SingleNewsModel singleNews = SingleNewsModel.fromJsonPrimaCremona(jsonData);

    return singleNews;
  }
}
