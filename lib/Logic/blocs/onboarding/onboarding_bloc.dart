import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samachar/Utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(CategoriesLoading()) {
    on<LoadCategories>(_onLoadCategories);
    on<Dataloaded>(_onDataLoaded);
  }

  void _onLoadCategories(
      LoadCategories event, Emitter<OnboardingState> emit) async {
    //emit(NewsLoading());
    try {
      final categoriesList = NewsCategories.values
          .map((e) => e.toString().split('.').last)
          .toList();
      emit(CategoriesLoaded(categoriesList));
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  void _onDataLoaded(Dataloaded event, Emitter<OnboardingState> emit) async {
    // save the data into the Isar Database
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', event.name);
      await prefs.setString('location', event.location);
      await prefs.setStringList('categories', event.selectedCategories);
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
    emit(const DataSaved("Data Saved Successfully!"));
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name') ?? '';
    String location = prefs.getString('location') ?? '';
    List<String> selectedCategories = prefs.getStringList('categories') ?? [];
    emit(OnBoardingDataLoaded(name, location, selectedCategories));
  }
}
