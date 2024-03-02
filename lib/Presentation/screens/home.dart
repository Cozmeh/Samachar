import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar/Logic/blocs/news/news_bloc.dart';
import 'package:samachar/Logic/blocs/onboarding/onboarding_bloc.dart';
import 'package:samachar/Logic/blocs/weather/weather_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:samachar/Presentation/screens/category_feed.dart';
import 'package:samachar/Presentation/screens/downloads.dart';
import 'package:samachar/Presentation/screens/main_feed.dart';
import 'package:samachar/Presentation/screens/settings.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? name;
  String? location;
  List<String>? selectedCategories;

  // network variables
  // bool isOnline = true;
  final Connectivity _connectivity = Connectivity();

  void checkConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    connectionChecker(connectivityResult);
  }

  void connectionChecker(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      var snackBar = const SnackBar(
        duration: Duration(seconds: 3),
        content: Center(
          child: Text("No Internet Connection"),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        currentindex = 2;
      });
    } else {
      setState(() {
        currentindex = 1;
      });
    }
  }

  // assign the data to the variables
  // Future<void> _loadData() async {
  //   Map<String, dynamic> data = await loadData();
  //   setState(() {
  //     name = data['name'];
  //     location = data['location'];
  //     selectedCategories = List<String>.from(data['selectedCategories']);
  //   });
  // }

  // load the data from the shared preferences

  int currentindex = 0;
  List<Widget> pages() {
    return [
      const NewsFeed(),
      CategoryFeed(selectedCategories: selectedCategories),
      const Downloads(),
      Settings(
        name: name,
        location: location,
        selectedCategories: selectedCategories,
      ),
    ];
  }

  // List<Widget> pages = [
  //   const NewsFeed(),
  //   CategoryFeed( selectedCategories: selectedCategories),
  //   const Downloads(),
  //   const Settings(),
  // ];

  @override
  void initState() {
    checkConnectivity();
    // _loadData();
    BlocProvider.of<OnboardingBloc>(context).loadData();
    BlocProvider.of<NewsBloc>(context).add(LoadNews());
    // run when clicked on the weather icon
    // BlocProvider.of<WeatherBloc>(context).add(GetWeather(location!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<WeatherBloc>(context).add(GetWeather('Bengaluru'));
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is OnBoardingDataLoaded) {
          name = state.name;
          location = state.location;
          String loc = state.location;
          selectedCategories = state.selectedCategories;
          // print(state.name);
          // print(state.location);
          // print(state.selectedCategories);
          // location = state.location;
          // selectedCategories = state.selectedCategories;
          BlocProvider.of<WeatherBloc>(context).add(GetWeather(loc));
        }
        return WillPopScope(
          onWillPop: () async {
            var exitBar = SnackBar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              content: const Text(
                "Do you want to Exit ?",
                style: TextStyle(color: Colors.black),
              ),
              action: SnackBarAction(
                  label: "Yes",
                  textColor: Colors.black,
                  onPressed: () {
                    SystemNavigator.pop();
                  }),
            );
            ScaffoldMessenger.of(context).showSnackBar(exitBar);
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              surfaceTintColor: Theme.of(context).colorScheme.surface,
              title: const Text('Samachar',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              centerTitle: false,
              actions: [
                BlocBuilder<WeatherBloc, WeatherState>(
                  builder: (context, wState) {
                    if (wState is WeatherLoading) {
                      return const CircularProgressIndicator();
                    }
                    if (wState is WeatherLoaded) {
                      return TextButton(
                        onPressed: () {
                          showWeatherBottomSheet(context, wState);
                        },
                        child: Row(
                          children: [
                            Text(
                              '${wState.weather.temperature} °C',
                              style: TextStyle(
                                  color: Theme.of(context).iconTheme.color,
                                  fontSize: 15),
                            ),
                            const SizedBox(
                              width: 5,
                              height: 5,
                            ),
                            Icon(
                              Icons.stream_rounded,
                              color: wState.weather.temperature > 20
                                  ? Colors.yellow
                                  : Colors.blue,
                            ),
                          ],
                        ),
                      );
                    }
                    if (wState is WeatherError) {
                      print(wState.errorMessage);
                      return TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Error",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      );
                    }
                    return const Text(':(');
                  },
                ),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              surfaceTintColor: Theme.of(context).colorScheme.background,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.newspaper),
                  label: 'News',
                ),
                NavigationDestination(
                  icon: Icon(Icons.category),
                  label: 'Category',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bookmarks),
                  label: 'Downloads',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
              selectedIndex: currentindex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentindex = index;
                });
              },
            ),
            body: pages()[currentindex],
          ),
        );
      },
    );
  }

  // bottomsheet for weather
  void showWeatherBottomSheet(BuildContext context, var state) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            height: 200,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                child: Column(
                  children: [
                    ListTile(
                      leading: greetingIcon(),
                      title: Text(
                        "${_greetMessage()},\n$name!",
                        style: const TextStyle(fontSize: 25),
                      ),
                      trailing: Text(
                        "${state.weather.temperature} °c",
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        weatherCards('Feels Like',
                            "${state.weather.apparentTemperature} °c"),
                        weatherCards(
                            'Cloud Cover', '${state.weather.cloudCover}%'),
                      ],
                    ),
                    const SizedBox()
                  ],
                ),
              ),
            ),
          );
        });
    // }
  }

  greetingIcon() {
    if (_greetMessage() == 'Good morning') {
      return const Icon(Icons.wb_sunny);
    } else if (_greetMessage() == 'Good afternoon') {
      return const Icon(Icons.wb_cloudy);
    } else {
      return const Icon(Icons.nightlight_round);
    }
  }

  weatherCards(String title, String value) {
    return SizedBox(
      width: 150,
      height: 100,
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 15),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _greetMessage() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }
}






/*Container(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GNav(
              color: Theme.of(context).iconTheme.color,
              activeColor: Colors.green,
              tabBackgroundColor: Colors.green.shade100,
              tabBorderRadius: 20,
              padding: const EdgeInsets.all(10),
              gap: 10,
              tabs: const [
                GButton(
                  icon: Icons.newspaper,
                  text: 'News',
                ),
                GButton(
                  icon: Icons.category,
                  text: 'Category',
                ),
                GButton(
                  icon: Icons.bookmarks,
                  text: 'Downloads',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
            ),
          ),
        ) */