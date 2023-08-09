// ignore_for_file: avoid_print, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/ob/daily_weather_ob.dart';
import 'package:weather/utils/app_constants.dart';
import 'package:weather/widget/daily_widget.dart';

class DailyForecastPage extends StatefulWidget {
  double? lat;
  double? lon;
  DailyForecastPage(this.lat, this.lon, {super.key});

  @override
  State<DailyForecastPage> createState() => _DailyForecastPageState();
}

class _DailyForecastPageState extends State<DailyForecastPage> {
  //https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&exclude=hourly,daily&appid={API key}

  DailyWeatherOb dwob = DailyWeatherOb();
  bool isLoading = true;
  getDailyWheatherData() async {
    print(
        "$DAILY_BASE_URL?lat=${widget.lat}&lon=${widget.lon}&exclude=hourly,minutely,monthly&appid=$APPID&units=metric");
    var response = await http.get(Uri.parse(
        "$DAILY_BASE_URL?lat=${widget.lat}&lon=${widget.lon}&exclude=hourly,minutely,monthly&appid=$APPID&units=metric"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        dwob = DailyWeatherOb.fromJson(json.decode(response.body));
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("error");
    }
  }

  @override
  void initState() {
    getDailyWheatherData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo, Colors.blue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 5,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10.0, height: 10.0),
                  const Text(
                    "Pronóstico de 7 días",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: dwob.daily!.length,
                      itemBuilder: (context, index) {
                        return DailyWidget(dwob.daily![index]);
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
