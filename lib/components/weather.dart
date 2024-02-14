import 'package:cremona_hub/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:weather_animation/weather_animation.dart';

class Weather extends StatelessWidget {
  final Future<WeatherModel> weatherFuture;

  const Weather({required this.weatherFuture, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
      child: FutureBuilder<WeatherModel>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildWeatherWidget(context, snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildWeatherWidget(BuildContext context, WeatherModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          fit: FlexFit.tight,
          child: buildWeatherScene(data),
        ),
        Flexible(
          flex: 3,
          fit: FlexFit.tight,
          child: buildWeatherDetails(data),
        ),
      ],
    );
  }

  Widget buildWeatherScene(WeatherModel data) {
    switch (data.icon) {
      case 'clear-day':
      case 'clear-night':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [SunWidget(sunConfig: SunConfig(width: 450))],
        );
      case 'cloudy':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [
            CloudWidget(cloudConfig: CloudConfig(color: Color(0xFFE0F7FA)))
          ],
        );
      case 'partly-cloudy-day':
      case 'partly-cloudy-night':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [
            SunWidget(sunConfig: SunConfig(width: 450)),
            CloudWidget(cloudConfig: CloudConfig(color: Color(0xFFE0F7FA))),
          ],
        );
      case 'wind':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [WindWidget(windConfig: WindConfig())],
        );
      case 'rain':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [
            CloudWidget(cloudConfig: CloudConfig(color: Color(0xFFE0F7FA))),
            RainWidget(rainConfig: RainConfig(color: Color(0xff2980b9))),
          ],
        );
      case 'sleet':
      case 'snow':
        return const WrapperScene(
          sizeCanvas: Size(450, 110),
          colors: [Color(0x00000000)],
          children: [
            CloudWidget(cloudConfig: CloudConfig(color: Color(0xFFE0F7FA))),
            SnowWidget(snowConfig: SnowConfig(color: Color(0xffbdbdbd))),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget buildWeatherDetails(WeatherModel data) {
    return SizedBox(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Cremona 🎻',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            '${data.temperature}°C',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
