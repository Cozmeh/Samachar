import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:samachar/Logic/blocs/onboarding/onboarding_bloc.dart';
import 'package:samachar/Presentation/screens/home.dart';

class OnBoarder extends StatefulWidget {
  const OnBoarder({super.key});

  @override
  State<OnBoarder> createState() => _OnBoarderState();
}

class _OnBoarderState extends State<OnBoarder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // late Position position;
  @override
  void initState() {
    // gets the current location of the user
    // _getlocation();
    BlocProvider.of<OnboardingBloc>(context).add(LoadCategories());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // return the lat and long of the user
  // Future<Position> _getlocation() async {
  //   bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!isServiceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   var location = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   position = location;
  //   return location;
  // }

  // _updateCity(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark place = placemarks[0];
  //   print(place.locality);
  // }

  // list of selections
  final List<String> _selectedCategories = [];

  showCategories() {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state is DataSaved) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const Home();
            }));
          });
        }
        if (state is CategoriesLoading) {
          return const CircularProgressIndicator();
        }
        if (state is CategoriesLoaded) {
          return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.categoriesList.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  dense: true,
                  title: Text(state.categoriesList[index]),
                  value:
                      _selectedCategories.contains(state.categoriesList[index]),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCategories.add(state.categoriesList[index]);
                      } else {
                        _selectedCategories.remove(state.categoriesList[index]);
                      }
                      print(_selectedCategories);
                    });
                  },
                );
              });
        }
        if (state is OnboardingError) {
          return Text(state.message);
        }
        return const Text('Could not load categories :(');
      },
    );
  }

  Widget space = const SizedBox(
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            child: Column(
              children: [
                space,
                space,
                const Text(
                  'Welcome to Samachar!',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                space,
                TextField(
                  controller: _nameController,
                  maxLength: 15,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please enter your name',
                    labelText: 'Name',
                  ),
                ),
                space,
                TextField(
                  controller: _locationController,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Please enter your location (city)',
                    labelText: 'Location',
                  ),
                ),
                space,
                const Text(
                  'Please select your preferred categories :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                space,
                Expanded(
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: showCategories(),
                    ),
                  ),
                ),
                space,
                ElevatedButton(
                  style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all(const Size(200, 50))),
                  onPressed: _continue,
                  child: const Text('Continue'),
                ),
                space,
              ],
            ),
          ),
        ),
      ),
    );
  }

  _continue() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
    } 
    else if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your location'),
        ),
      );
    } 
    else if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one category'),
        ),
      );
    } else {
      if (RegExp(r"^[A-Za-z]+$").hasMatch(_nameController.text.toString())) {
        BlocProvider.of<OnboardingBloc>(context).add(Dataloaded(
            name: _nameController.text,
            location: _locationController.text,
            selectedCategories: _selectedCategories));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please make sure it alphabet only'),
          ),
        );
      }
    }
  }
}
