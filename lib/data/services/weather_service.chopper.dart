// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$WeatherService extends WeatherService {
  _$WeatherService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = WeatherService;

  @override
  Future<Response<dynamic>> getWeather({
    required double latitude,
    required double longitude,
    String current = "temperature_2m,cloud_cover,apparent_temperature",
  }) {
    final Uri $url = Uri.parse('/forecast');
    final Map<String, dynamic> $params = <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'current': current,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
