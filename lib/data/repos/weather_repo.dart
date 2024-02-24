import 'package:samachar/Data/models/weather_model.dart';
import 'package:samachar/Data/services/weather_service.dart';
import 'package:samachar/Data/services/location_service.dart';
import 'package:samachar/Data/models/location_model.dart';

class WeatherRepository {
  final WeatherService _weatherService;
  final LocationService _locationService;

  WeatherRepository(this._weatherService,this._locationService);

  // for getting the weather
  Future<Weather> getWeather(double lat, double lon) async {
    try {
      final response =
          await _weatherService.getWeather(latitude: lat, longitude: lon);
      if (response.isSuccessful) {
        final data = response.body;
        // print("Testing  ${response.headers}");
        print("Testing  ${data["current"]}");
        return Weather.fromJson(data["current"]);
      } else {
        throw Exception('Failed to fetch weather');
      }
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  // for getting the location
  Future<List<Location>> getLocation(String name) async {
    try {
      final response = await _locationService.getlocation(name: name);
      if (response.isSuccessful) {
        final data = response.body;
        final List<dynamic> jsonList = data['results'];
        // NOTE map coz multiple locations can be returned (search)
        return jsonList.map((e) => Location.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      throw Exception('Failed to fetch locations: $e');
    }
  }

  static WeatherRepository create() {
    final weatherService = WeatherService.create();
    final locationService = LocationService.create();
    return WeatherRepository(weatherService,locationService);
  }
}
