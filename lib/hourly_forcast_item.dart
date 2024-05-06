import 'package:flutter/material.dart';
import 'package:weather/weather.dart';

class hourly_forcast_item extends StatelessWidget {
  final String time, temp, image;

  const hourly_forcast_item({
    super.key,
    required this.time,
    required this.temp,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        color: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Image.asset(image),
              const SizedBox(
                height: 5,
              ),
              Text(
                temp,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
