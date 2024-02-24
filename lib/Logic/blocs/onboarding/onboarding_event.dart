part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object> get props => [];
}

final class LoadCategories extends OnboardingEvent {}

final class Dataloaded extends OnboardingEvent{
  final String name;
  final String location;
  final List<String> selectedCategories;

  const Dataloaded({required this.selectedCategories, required this.name, required this.location});
  
  @override
  List<Object> get props => [selectedCategories, name, location];
}