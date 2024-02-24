part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class GetWeather extends WeatherEvent {
  final String location;

  const GetWeather(this.location);

  @override
  List<Object> get props => [location];
}
