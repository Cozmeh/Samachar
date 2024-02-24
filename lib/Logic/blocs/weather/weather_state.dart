part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object> get props => [];
}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherLoaded extends WeatherState {
  final Weather weather;

  const WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

final class WeatherError extends WeatherState {
  final String errorMessage;

  const WeatherError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
