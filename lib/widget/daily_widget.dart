import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/ob/daily_weather_ob.dart';

class DailyWidget extends StatelessWidget {
  Daily daily;
  DailyWidget(this.daily, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.blueAccent,
                title: Text(
                  DateFormat("EEEE dd, MMMM, yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(daily.dt! * 1000)),
                  style: const TextStyle(color: Colors.white),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                        "http://openweathermap.org/img/wn/${daily.weather![0].icon}@2x.png"),
                    Text(
                      daily.weather![0].main!,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      "Max Temperature : ${daily.temp!.max.toString()} C",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Mim Temperature : ${daily.temp!.min.toString()} C",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Day Temperature : ${daily.temp!.day.toString()} C",
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Night Temperature : ${daily.temp!.night.toString()} C",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                    "http://openweathermap.org/img/wn/${daily.weather![0].icon}@2x.png"),
                Text(
                  daily.weather![0].main!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            Text(
              DateFormat("EEEE dd, MMMM, yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(daily.dt! * 1000)),
              style: const TextStyle(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
