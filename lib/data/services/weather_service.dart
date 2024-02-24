import "package:chopper/chopper.dart";
import "package:samachar/utils/constants.dart";

part "weather_service.chopper.dart";

@ChopperApi(baseUrl: Constants.WEATHER_BASE_URL)
abstract class WeatherService extends ChopperService {
  @Get(path: "/forecast")
  Future<Response> getWeather({
    @Query("latitude") required double latitude,
    @Query("longitude") required double longitude,
    @Query("current") String current = "temperature_2m,cloud_cover,apparent_temperature" ,
  });

  static WeatherService create() {
    final client = ChopperClient(
      baseUrl: Uri.tryParse(Constants.WEATHER_BASE_URL),
      services: [_$WeatherService()],
      converter: const JsonConverter(),
    );
    return _$WeatherService(client);
  }
}
