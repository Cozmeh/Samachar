import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:samachar/data/database/news_database.dart';
import 'package:samachar/Data/repos/news_repo.dart';
import 'package:samachar/Data/repos/weather_repo.dart';
import 'package:samachar/Logic/blocs/news/news_bloc.dart';
import 'package:samachar/Logic/blocs/offlineNews/offline_news_bloc.dart';
import 'package:samachar/Logic/blocs/onboarding/onboarding_bloc.dart';
import 'package:samachar/Logic/blocs/weather/weather_bloc.dart';
import 'package:samachar/Presentation/screens/home.dart';
import 'package:samachar/Presentation/screens/onboarder.dart';
import 'package:samachar/Presentation/themes/theme_provider.dart';
import 'package:samachar/Presentation/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NewsDatabase.initialize();
  // first time launch check
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstTime = prefs.getBool('first') ?? true;
  if (firstTime) {
    await prefs.setBool('first', false);
  }
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Newsapp(firstTime: firstTime)));
}

class Newsapp extends StatefulWidget {
  final bool firstTime;
  const Newsapp({super.key, required this.firstTime});

  @override
  State<Newsapp> createState() => _NewsappState();
}

class _NewsappState extends State<Newsapp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NewsBloc(NewsRepository.create()),
          ),
          BlocProvider(
            create: (context) => WeatherBloc(WeatherRepository.create()),
          ),
          BlocProvider(
            create: (context) => OnboardingBloc(),
          ),
          BlocProvider(
            create: (context) => OfflineNewsBloc(NewsDatabase()),
          )
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightMode, /*Provider.of<ThemeProvider>(context).themeData*/
            darkTheme: darkMode,
            themeMode: ThemeMode.system,
            home: widget.firstTime ? const OnBoarder() : const Home()));
  }

  // callnews() async {
  //   var newsList = await NewsRepository.create().getNews();
  //   for (var news in newsList) {
  //     print('Title: ${news.title}');
  //     print('Description: ${news.description}');
  //     print('URL: ${news.url}');
  //     print('URL to Image: ${news.urlToImage}');
  //     print('Published At: ${news.publishedAt}');
  //     print('Content: ${news.content}');
  //     print('------------------------------------------');
  //   }
  // }

  // getLocation(String location) async {
  //   var locationList = await WeatherRepo.create().getLocation(location);
  //   for (var location in locationList) {
  //     print('Name: ${location.name}');
  //     print('Country: ${location.country}');
  //     print('Latitude: ${location.latitude}');
  //     print('Longitude: ${location.longitude}');
  //     print('------------------------------------------');
  //   }
  //   getWeather(locationList[0].latitude, locationList[0].longitude);
  // }

  // getWeather(double lat, double long) async {
  //   var weather = await WeatherRepo.create().getWeather(lat, long);
  //   print('Temperature: ${weather.temperature}');
  //   print('Apparent Temp: ${weather.apparentTemperature}');
  //   print('Cloud Cover: ${weather.cloudCover}');
  // }
}
