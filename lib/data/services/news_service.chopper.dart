// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$NewsService extends NewsService {
  _$NewsService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = NewsService;

  @override
  Future<Response<dynamic>> getNews({
    String country = Constants.COUNTRY,
    String apiKey = Constants.NEWS_API_KEY,
  }) {
    final Uri $url = Uri.parse('/top-headlines');
    final Map<String, dynamic> $params = <String, dynamic>{
      'country': country,
      'apiKey': apiKey,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getCategoryNews({
    String apiKey = Constants.NEWS_API_KEY,
    String country = Constants.COUNTRY,
    String? category,
  }) {
    final Uri $url = Uri.parse('/top-headlines');
    final Map<String, dynamic> $params = <String, dynamic>{
      'apiKey': apiKey,
      'country': country,
      'category': category,
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
