import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samachar/Data/models/weather_model.dart';
import 'package:samachar/Data/repos/weather_repo.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository Weather;
  WeatherBloc(this.Weather) : super(WeatherLoading()) {
    on<GetWeather>(_onGetWeather);
  }

  void _onGetWeather(GetWeather event, Emitter<WeatherState> emit) async {
    //emit(WeatherLoading());
    try {
      final location = await Weather.getLocation(event.location);
      final weather = await Weather.getWeather(location[0].latitude, location[0].longitude);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}
