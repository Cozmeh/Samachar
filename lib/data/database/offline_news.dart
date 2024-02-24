import 'package:isar/isar.dart';

part 'offline_news.g.dart';

@Collection()
class OfflineNews {
  Id id = Isar.autoIncrement;
  late String title;
  late String description;
  late String url;
  late String urlToImage;
  late String publishedAt;
  late String content;
}
