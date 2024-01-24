import 'package:cremona_hub/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherRepository {
  Future<WeatherModel> getWeather() async {
    final response = await http.get(Uri.parse(
        'https://api.pirateweather.net/forecast/CJaGp1synE8YuDHvbzmY4t0Zwb5Gbj8A/45.133499,10.026130?&units=ca'));

    final jsonData = jsonDecode(response.body);

    WeatherModel currentWeather = WeatherModel.fromJson(jsonData);

    return currentWeather;
  }
}
