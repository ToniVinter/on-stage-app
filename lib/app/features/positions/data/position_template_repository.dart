import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/positions/domain/create_or_edit_position_request.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'position_template_repository.g.dart';

@RestApi()
abstract class PositionTemplateRepository {
  factory PositionTemplateRepository(Dio dio) = _PositionTemplateRepository;

  @GET(API.getPositions)
  Future<List<Position>> getPositionsTemplate(
    @Path('id') String id,
  );

  @POST(API.createPositon)
  Future<Position> addPosition(
    @Body() CreateOrEditPositionRequest position,
  );

  @PUT(API.updatePosition)
  Future<Position> updatePosition(
    @Path('id') String id,
    @Body() CreateOrEditPositionRequest group,
  );

  @DELETE(API.deletePosition)
  Future<void> deletePosition(@Path('id') String id);
}

final positionRepositoryProvider = Provider<PositionTemplateRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return PositionTemplateRepository(dio);
});
