import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/additional_info_item.dart';
import 'package:weatherapp/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weatherapp/secrets.dart';

class weather_screen extends StatefulWidget {
  const weather_screen({super.key});

  @override
  State<weather_screen> createState() => _weather_screenState();
}

class _weather_screenState extends State<weather_screen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = "Potsdam";
      String countryName = "germany";
      final result = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,$countryName&APPID=$openWeatherMapApiKey&units=metric'),
      );
      final data = jsonDecode(result.body);
      if (data['cod'] != '200') {
        throw data['message'];
      }
      return data;

      //  (data['list'][0]['main']['temp']);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Weather App",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                print('Pressed');
              },
              icon: Icon(Icons.menu),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getCurrentWeather(),
          builder: (context, snapshot) {
            print(snapshot);

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }

            final data = snapshot.data!;
            final currentTemp = data['list'][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            var forecastTime = data['list'][0]['dt_txt'];
            // forecastTime =
            //     DateTime.parse(forecastTime).timeZoneOffset.toString();
            final humidity = data['list'][0]['main']['humidity'];
            // final currentSky = data['timezone'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      forecastTime,
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ),
                  // MainCard()
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp °C',
                                  style: const TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Image.asset(
                                  'images/6.png',
                                  scale: 7.0,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  currentSky,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Hourly Forecast',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
//for this 15:51:00
                  // SizedBox(
                  //   height: 120,
                  //   child: ListView.builder(
                  //     itemCount: 5,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       final hourlyForecast = data['list'][index + 1];
                  //       final hourlySky =
                  //           data['list'][index + 1]['weather'][0]['main'];
                  //       final hourlyTemp =
                  //           hourlyForecast['main']['temp'].toString();
                  //       final time = DateTime.parse(hourlyForecast['dt_txt']);
                  //       return hourlyForecast(
                  //         time: DateFormat.j().format(time),
                  //         temperature: hourlyTemp,
                  //         icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                  //             ? Icons.cloud
                  //             : Icons.sunny,
                  //       );
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < 10; i++)
                          hourly_forcast_item(
                              time: data['list'][i + 1]['dt_txt'],
                              temp: data['list'][i + 1]['main']['temp']
                                  .toString(),
                              image: 'images/8.png'),
                        // hourly_forcast_item(
                        //     time: '11:00', temp: '26°C', image: 'images/7.png'),
                        // hourly_forcast_item(
                        //     time: '12:00', temp: '29°C', image: 'images/6.png'),
                        // hourly_forcast_item(
                        //   time: '13:00',
                        //   temp: '30°C',
                        //   image: 'images/6.png',
                        // ),
                        // hourly_forcast_item(
                        //     time: '14:00', temp: '26°C', image: 'images/7.png'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Additional Information',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      additional_info_item(
                        icon: (Icons.water_drop),
                        text: 'Humidity',
                        value: '$humidity',
                      ),
                      const additional_info_item(
                        icon: Icons.wind_power,
                        text: 'Wind Speed',
                        value: '8.5km/h',
                      ),
                      const additional_info_item(
                        icon: Icons.light_mode_outlined,
                        text: 'UV Index',
                        value: 'low',
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// 15:56:00
// Icon change assording to apidata 15:22:00