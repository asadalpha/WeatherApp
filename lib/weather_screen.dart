import 'dart:convert';
import 'dart:ui';
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';
import 'info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Ranchi";
      final res = await http.get(Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$APIKey"));

      final data = jsonDecode(res.body);
      if (data['cod'] != "200") {
        throw "An Unexpected error Occurred";
      }
      return data;
      //data['list'][0]['main']['temp']
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  weather = getCurrentWeather();
                });
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text(
          "Weather App",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          //for error handling
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentTemp = data['list'][0]['main']['temp'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentHumidity = data['list'][0]['main']['humidity'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];

          final temp = (currentTemp - 273.15).round();
          final city = data['city']['name'];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Weather in $city",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Text(
                            "$temp °C",
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Icon(
                            currentSky == "Clouds" || currentSky == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            size: 55,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "$currentSky",
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w400),
                          ),
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Weather Forecast",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i = 0; i < 5; i++)
              //         ForeCastBox(
              //           txt1: data['list'][i + 1]['dt'].toString(),
              //           txt2: data['list'][i + 1]['main']['temp'].toString(),
              //           icon: data['list'][i + 1]['weather'][0]['main'] ==
              //                       "Clouds" ||
              //                   data['list'][i + 1]['weather'][0]['main'] ==
              //                       "Rain"
              //               ? Icons.cloud
              //               : Icons.sunny,
              //         ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final temp1 = (data['list'][index + 1]['main']['temp']);
                      final hourlyTemp = (temp1 - 273.15).round();
                      final time =
                          DateTime.parse(data['list'][index + 1]['dt_txt']);
                      return ForeCastBox(
                        txt1: DateFormat('j').format(time),
                        txt2: "$hourlyTemp °C",
                        icon: data['list'][index + 1]['weather'][0]['main'] ==
                                    "Clouds" ||
                                data['list'][index + 1]['weather'][0]['main'] ==
                                    "Rain"
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Additional Information",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AdditionalInfoBox(
                    icon: Icons.water_drop,
                    txt1: "Humidity",
                    txt2: "$currentHumidity",
                  ),
                  AdditionalInfoBox(
                    icon: Icons.air_sharp,
                    txt1: "Wind Speed",
                    txt2: "$currentWindSpeed",
                  ),
                  AdditionalInfoBox(
                    icon: Icons.beach_access,
                    txt1: "Pressure",
                    txt2: "$currentPressure",
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
