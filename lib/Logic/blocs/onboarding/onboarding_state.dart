part of 'onboarding_bloc.dart';

sealed class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object> get props => [];
}

final class OnboardingInitial extends OnboardingState {}

final class CategoriesLoading extends OnboardingState {}

final class CategoriesLoaded extends OnboardingState{
  final List<String> categoriesList;

  const CategoriesLoaded(this.categoriesList);

  @override
  List<Object> get props => [categoriesList];
}

final class DataSaved extends OnboardingState {
  final String mesaage;

  const DataSaved(this.mesaage);

  @override
  List<Object> get props => [mesaage];
}

final class OnboardingError extends OnboardingState{
  final String message;

  const OnboardingError(this.message);

  @override
  List<Object> get props => [message];
}

final class OnBoardingDataLoaded extends OnboardingState {
  final String name;
  final String location;
  final List<String> selectedCategories;

  const OnBoardingDataLoaded(this.name, this.location, this.selectedCategories);

  @override
  List<Object> get props => [name, location, selectedCategories];
}