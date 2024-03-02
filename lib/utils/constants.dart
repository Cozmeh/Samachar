// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Constants {

  static const String COUNTRY = "in";

  static const String BASE_URL = "https://newsapi.org/v2";

  // causing error
  // static const String WEATHER_BASE_URL = "https://api.openweathermap.org/data/2.5";
  static const String WEATHER_BASE_URL = "https://api.open-meteo.com/v1";
  // for location
  static const String LOCATION_URL = "https://geocoding-api.open-meteo.com/v1";


  // main colors
  static const Color PRIMARY = Colors.greenAccent;
  static Color SECONDARY = Colors.green.shade100;
  static Color LIGHT_BACKGROUND = Colors.grey.shade300;
  static const Color DARK_BACKGROUND = Color.fromARGB(255, 22, 22, 22);
  // color for cards , nav bar and other surfaces
  static Color LIGHT_SURFACE = Colors.grey.shade200;
  static Color DARK_SURFACE = Colors.black;
}


// https://api.open-meteo.com/v1/forecast?latitude=12.97194&longitude=77.59369&current=temperature_2m,cloud_cover
// /search?name=Bengaluru&count=1&language=en&format=json