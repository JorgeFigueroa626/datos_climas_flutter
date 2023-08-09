// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:weather/ob/weather_ob.dart';
import 'package:weather/page/daily_forecast_page.dart';
import 'package:weather/page/search_by_city_page.dart';
import 'package:weather/utils/app_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //String url ="api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}";
  //String appId = "73d78652fc13ca6011304dc53dfa6119";

  WeatherOb wob = WeatherOb();

  bool isLoading = true;
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  double? lat;
  double? lon;

  getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData!.latitude);
    print(_locationData!.longitude);
    lat = _locationData!.latitude;
    lon = _locationData!.longitude;

    var response = await http.get(
        Uri.parse("$BASE_URL?lat=$lat&lon=$lon&appid=$APPID&units=metric"));
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        wob = WeatherOb.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      print("error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    int hour = DateTime.now().hour;
    bool isNigt = true;
    if (hour >= 6 && hour <= 18) {
      isNigt = false;
    }
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      child: Image.asset(
                        isNigt?'images/noche.png':
                        'images/dia.png',
                        fit: BoxFit.cover,
                      ),
                      // decoration: const BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [Colors.indigo, Colors.blue],
                      //     begin: Alignment.topLeft,
                      //     end: Alignment.bottomRight,
                      //   ),
                      // ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 20,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wob.name.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat("EEEE dd, MMMM").format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            DateFormat().add_jm().format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return DailyForecastPage(lat, lon);
                                },
                              ));
                            },
                            child: const Text(
                              "Pronóstico de 7 días",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${wob.main!.temp.toString()} C",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.network(
                                  "http://openweathermap.org/img/wn/${wob.weather![0].icon}.png"),
                            ),
                            Text(
                              wob.weather![0].main!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 95,
                    child: IconButton(
                      icon: const Icon(Icons.search,
                          color: Colors.white, size: 30),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const SearchByCityPage();
                          },
                        ));
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
