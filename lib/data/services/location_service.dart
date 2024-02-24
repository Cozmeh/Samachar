import "package:chopper/chopper.dart";
import "package:samachar/utils/constants.dart";

part "location_service.chopper.dart";

@ChopperApi(baseUrl: Constants.LOCATION_URL)
abstract class LocationService extends ChopperService {
  @Get(path: "/search")
  Future<Response> getlocation({
    @Query("name") required String name,
    @Query("count") int count = 1,
    @Query("language") String language = "en",
    @Query("format") String format = "json",
  });

  static LocationService create() {
    final client = ChopperClient(
      baseUrl: Uri.tryParse(Constants.LOCATION_URL),
      services: [_$LocationService()],
      converter: JsonConverter(),
    );
    return _$LocationService(client);
  }

}
