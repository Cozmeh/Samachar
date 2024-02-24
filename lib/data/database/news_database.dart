import 'package:chopper/chopper.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:samachar/Data/database/offline_news.dart';

class NewsDatabase {
  static late Isar isar;

  // isar init
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([OfflineNewsSchema], directory: dir.path);
  }

  Future<bool> saveOfflineNews(OfflineNews news) async {
    List<OfflineNews> offlineNews = await getOfflineNews();
    // means the news is already saved
    if (offlineNews.any((element) => element.title == news.title)) {
      return true;
    } else {
      await isar.writeTxn(() => isar.offlineNews.put(news));
      return false;
    }
  }

  Future<List<OfflineNews>> getOfflineNews() async {
    return isar.offlineNews.where().findAll();
  }

  Future<void> deleteOfflineNews(int id) async {
    await isar.writeTxn(() => isar.offlineNews.delete(id));
  }
}
