import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:cremona_hub/models/news_model.dart';

class NewsListRepository {
  Future<String> getImageUrl(int featuredMedia) async {
    final mediaResponse = await http.get(Uri.parse(
        'https://primacremona.it/wp-json/wp/v2/media/$featuredMedia'));
    if (mediaResponse.statusCode == 200) {
      final mediaData = jsonDecode(mediaResponse.body);
      return mediaData['guid']['rendered'];
    } else {
      return 'https://img.freepik.com/premium-vector/photo-icon-picture-icon-image-sign-symbol-vector-illustration_64749-4409.jpg';
    }
  }

  Future<List<NewsModel>> getNewsList() async {
    final random = Random();
    final int randomNumber = random.nextInt(50) + 50;
    List<NewsModel> newsList = [];

    try {
      final responseFromCremonaOggi = await http.get(Uri.parse(
          'https://www.cremonaoggi.it/wp-json/wp/v2/posts?per_page=$randomNumber'));
      final responseFromPrimaCremona = await http.get(Uri.parse(
          'https://primacremona.it/wp-json/wp/v2/posts?per_page=$randomNumber'));

      if (responseFromCremonaOggi.statusCode == 200) {
        final jsonDataCremonaOggi = jsonDecode(responseFromCremonaOggi.body);
        if (jsonDataCremonaOggi is List) {
          newsList.addAll((jsonDataCremonaOggi as List)
              .map((json) => NewsModel.fromJson(json, 'Cremona Oggi'))
              .toList());
        } else {
          print('Unexpected data format from first endpoint');
        }
      } else {
        print('Failed to load news list from first endpoint');
      }

      if (responseFromPrimaCremona.statusCode == 200) {
        final jsonDataPrimaCremona = jsonDecode(responseFromPrimaCremona.body);
        if (jsonDataPrimaCremona is List) {
          for (var json in jsonDataPrimaCremona) {
            final featuredMedia = json['featured_media'];
            String imageUrl =
                'https://img.freepik.com/premium-vector/photo-icon-picture-icon-image-sign-symbol-vector-illustration_64749-4409.jpg'; // Immagine predefinita
            if (featuredMedia != null) {
              imageUrl = await getImageUrl(featuredMedia);
            }
            final newsModel =
                NewsModel.fromJsonPrimaCremona(json, 'Prima Cremona', imageUrl);
            newsList.add(newsModel);
          }
        } else {
          print('Unexpected data format from second endpoint');
        }
      } else {
        print('Failed to load news list from second endpoint');
      }

      if (newsList.isEmpty) {
        throw Exception('Failed to load news list from both endpoints');
      }

      return newsList;
    } catch (e) {
      print('Failed to load news list: $e');
      // Handle the exception as needed
      return []; // Return an empty list on exception
    }
  }
}
