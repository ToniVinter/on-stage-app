import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'artist_repository.g.dart';

@RestApi(baseUrl: API.baseUrl)
abstract class ArtistRepository {
  factory ArtistRepository(Dio dio) = _ArtistRepository;

  @GET(API.artists)
  Future<List<Artist>> getArtists();
}
