class WeatherModel {
  final String icon;
  final double temperature;

  WeatherModel({required this.icon, required this.temperature});

  factory WeatherModel.fromJson(Map<String, dynamic> data) {
    return WeatherModel(
      icon: data['currently']['icon'],
      temperature:
          double.parse((data['currently']['temperature']).toStringAsFixed(1)),
    );
  }
}
