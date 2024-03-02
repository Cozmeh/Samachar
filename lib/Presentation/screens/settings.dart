import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:samachar/Logic/blocs/onboarding/onboarding_bloc.dart';
import 'package:samachar/Presentation/screens/home.dart';
import 'package:samachar/Presentation/themes/theme_provider.dart';

class Settings extends StatefulWidget {
  final String? name;
  final String? location;
  final List<String>? selectedCategories;

  const Settings(
      {super.key,
      required this.name,
      required this.location,
      required this.selectedCategories});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final List<String> _selectedCategories = [];
  final bool _isSwitched = false;

  // late Position position;
  @override
  void initState() {
    _nameController.text = widget.name!;
    _locationController.text = widget.location!;
    _selectedCategories.addAll(widget.selectedCategories!);
    BlocProvider.of<OnboardingBloc>(context).add(LoadCategories());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // list of selections

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
                var category = state.categoriesList[index];
                var isSelected = _selectedCategories.contains(category);
                return CheckboxListTile(
                  dense: true,
                  title: Text(state.categoriesList[index]),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value!) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: const Icon(Icons.light_mode),
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        })
                  ],
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
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Theme.of(context).iconTheme.color),
                  ),
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
    } else if (_locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your location'),
        ),
      );
    } else if (_selectedCategories.isEmpty) {
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
