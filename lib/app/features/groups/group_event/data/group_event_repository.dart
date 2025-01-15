import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'group_event_repository.g.dart';

@RestApi()
abstract class GroupEventRepository {
  factory GroupEventRepository(Dio dio) = _GroupEventRepository;

  @GET(API.groupsForEvent)
  Future<List<GroupEvent>> getGroups(
    @Path('eventId') String eventId,
  );

  @GET(API.groupEventById)
  Future<GroupEvent> getGroupById(
    @Path('eventId') String eventId,
    @Path('groupId') String groupId,
  );
}

final groupEventRepoProvider = Provider<GroupEventRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return GroupEventRepository(dio);
});
