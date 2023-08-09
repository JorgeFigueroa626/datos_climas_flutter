// ignore_for_file: avoid_print, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/ob/weather_ob.dart';
import 'package:weather/utils/app_constants.dart';

class SearchByCityPage extends StatefulWidget {
  const SearchByCityPage({super.key});

  @override
  State<SearchByCityPage> createState() => _SearchByCityPageState();
}

class _SearchByCityPageState extends State<SearchByCityPage> {
  WeatherOb? wob;
  bool isLoading = false;
  String? error;
  TextEditingController _cityTec = TextEditingController();

  getWeatherData(String cityName) async {
    setState(() {
      isLoading = true;
    });
    print(cityName);

    var response = await http
        .get(Uri.parse("$BASE_URL?q=$cityName&appid=$APPID&units=metric"));

    if (response.statusCode == 200) {
      setState(() {
        wob = WeatherOb.fromJson(json.decode(response.body));
        isLoading = false;
        error = null;
      });
    } else {
      error = "No se encontro informacion";
      isLoading = false;
    }
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
                      Icons.keyboard_arrow_left_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10.0, height: 10.0),
                  const Text(
                    "Estado de Clima",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityTec,
                            decoration: const InputDecoration(
                              labelText: "Search By City",
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            getWeatherData(_cityTec.text);
                          },
                          icon: const Icon(Icons.search,
                              color: Colors.white, size: 30),
                        )
                      ],
                    ),
                  ),
                  isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : wob == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${wob!.main?.temp.toString()} C",
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
                                            "http://openweathermap.org/img/wn/${wob!.weather?[0].icon}.png"),
                                      ),
                                      Text(
                                        wob!.weather![0].main!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Wind Speed : ${wob!.wind!.speed.toString()} meter/sec",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Max Temp : ${wob!.main!.tempMax} C",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    "Mim Temp : ${wob!.main!.tempMin} C",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  /*
                      ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: Image.network(
                                "http://openweathermap.org/img/wn/${wob.weather![0].icon!}@2x.png"),
                          ),
                          title: Text(wob.main!.temp.toString()),
                          subtitle: Text(wob.weather![0].main!),
                        )
                        */
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
