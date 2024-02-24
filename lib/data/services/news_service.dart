import "package:samachar/utils/constants.dart";
import "package:chopper/chopper.dart";

part "news_service.chopper.dart";

@ChopperApi(baseUrl: Constants.BASE_URL)
abstract class NewsService extends ChopperService {
  @Get(path: "/top-headlines")
  Future<Response> getNews({
    @Query("country") String country = Constants.COUNTRY,
    @Query("apiKey") String apiKey = Constants.NEWS_API_KEY,
  });

  @Get(path: "/top-headlines")
  Future<Response> getCategoryNews({
    @Query("apiKey") String apiKey = Constants.NEWS_API_KEY,
    @Query("country") String country = Constants.COUNTRY,
    @Query("category") String? category,
  });

  static NewsService create() {
    final client = ChopperClient(
      baseUrl: Uri.tryParse(Constants.BASE_URL),
      services: [_$NewsService()],
      converter: JsonConverter(),
    );
    return _$NewsService(client);
  }
}
