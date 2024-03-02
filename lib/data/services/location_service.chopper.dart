// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$LocationService extends LocationService {
  _$LocationService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = LocationService;

  @override
  Future<Response<dynamic>> getlocation({
    required String name,
    int count = 1,
    String language = "en",
    String format = "json",
  }) {
    final Uri $url =
        Uri.parse('https://geocoding-api.open-meteo.com/v1/search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'count': count,
      'language': language,
      'format': format,
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
