import 'dart:async';
import 'package:flutter/material.dart';
import 'package:aditi_saini_app/model/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late Weather _weather;

  @override
  void initState() {
    getCurrentWeather();
    Timer.periodic(
        const Duration(seconds: 300), (timer) => getCurrentWeather());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot != null) {
          this._weather = snapshot.data as Weather;
          if (this._weather == null) {
            return Text("Error getting weather");
          } else {
            return weatherBox(_weather);
          }
        } else {
          return CircularProgressIndicator();
        }
      },
      future: getCurrentWeather(),
    );
  }
}

Widget weatherBox(Weather _weather) {

  return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          "Weather Api",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
              decoration: TextDecoration.underline),
        )),
    Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          "${_weather.temp}°C",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 55, color: Colors.blue),
        )),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(
          _weather.description,
          style: const TextStyle(color: Colors.black26),
        )),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("Feels:${_weather.feelsLike}°C",
            style: const TextStyle(color: Colors.deepPurple))),
    Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("H:${_weather.high}°C L:${_weather.low}°C",
            style: const TextStyle(color: Colors.amber))),
  ]);
}

Future getCurrentWeather() async {
  late Weather weather; // change
  var url = "https://api.openweathermap.org/data/2.5/weather?q=london&units=metric&appid=b2ddaf3419ff31f5243eac201d92c72e";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  }

  return weather;
}
