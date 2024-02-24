// news_repository.dart

import 'package:samachar/Data/models/news_model.dart';
import 'package:samachar/Data/services/news_service.dart';

class NewsRepository {
  final NewsService _newsService;

  NewsRepository(this._newsService);

  Future<List<News>> getNews() async {
    try {
      final response = await _newsService.getNews();
      if (response.isSuccessful) {
        print("success");
        final data = response.body;
        final List<dynamic> jsonList = data['articles'];
        return jsonList.map((e) => News.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch news');
      }
    } catch (e) {
      throw Exception('Failed to fetch news: $e');
    }
  }

  Future<List<News>> getCategoryNews(String category) async {
    try {
      final response = await _newsService.getCategoryNews(category: category);
      if (response.isSuccessful) {
        final data = response.body;
        final List<dynamic> jsonList = data['articles'];
        return jsonList.map((e) => News.fromJson(e)).toList();
      } else {
        throw Exception('Failed to fetch $category news');
      }
    } catch (e) {
      throw Exception('Failed to fetch $category news: $e');
    }
  }

  static NewsRepository create() {
    final newsService = NewsService.create();
    return NewsRepository(newsService);
  }
}
