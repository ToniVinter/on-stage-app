import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_update_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/duplicate_event_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_items_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_filter.dart';
import 'package:on_stage_app/app/features/event/domain/models/events_response.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_all_stagers_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/edit_stager_request.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/domain/models/upcoming_event/upcoming_event_model.dart';
import 'package:on_stage_app/app/utils/api.dart';
import 'package:retrofit/retrofit.dart';

part 'events_repository.g.dart';

@RestApi()
abstract class EventsRepository {
  factory EventsRepository(Dio dio) = _EventsRepository;

  @GET(API.eventsByFilter)
  Future<EventsResponse> getEvents({
    @Body() EventsFilter? eventsFilter,
  });

  @GET(API.upcomingEvent)
  Future<UpcomingEventModel?> getUpcomingEvent();

  @GET(API.eventById)
  Future<EventModel> getEventById(@Path('id') String id);

  @GET(API.rehearsals)
  Future<List<RehearsalModel>> getRehearsalsByEventId(
    @Query('eventId') String eventId,
  );

  @POST(API.rehearsals)
  Future<RehearsalModel> addRehearsal(
    @Body() RehearsalModel rehearsal,
  );

  @POST(API.eventItems)
  Future<List<EventItem>> addEventItems(
    @Body() EventItemsRequest eventItemsRequest,
  );

  @PUT(API.rehearsalById)
  Future<RehearsalModel> updateRehearsal(
    @Path('id') String rehearsalId,
    @Body() RehearsalModel rehearsal,
  );

  @DELETE(API.rehearsalById)
  Future<void> deleteRehearsal(
    @Path('id') String rehearsalId,
  );

  @GET(API.stagers)
  Future<List<Stager>> getStagersByEventId(
    @Query('eventId') String eventId,
  );

  @POST(API.events)
  Future<EventModel> createEvent(
    @Body() CreateUpdateEventModel? event,
  );

  @PUT(API.eventById)
  Future<EventModel> updateEvent(
    @Path('id') String eventId,
    @Body() CreateUpdateEventModel event,
  );

  @POST(API.duplicateEvent)
  Future<EventModel> duplicateEvent(
    @Path('id') String id,
    @Body() DuplicateEventRequest duplicateEventRequest,
  );

  @DELETE(API.eventById)
  Future<void> deleteEvent(
    @Path('id') String eventId,
  );

  ///Stagers
  @GET(API.stagers)
  Future<List<Stager>> getStagersByGroupAndEvent({
    @Query('eventId') required String eventId,
    @Query('groupId') required String groupId,
  });

  @POST(API.stagers)
  Future<List<Stager>> addStagerToEvent(
    @Body() CreateAllStagersRequest createStagerRequest,
  );

  @DELETE(API.stagersById)
  Future<String> removeStagerFromEvent(
    @Path('id') String id,
  );

  @PUT(API.editStagerById)
  Future<void> updateStager(
    @Path('id') String stagerId,
    @Body() EditStagerRequest stager,
  );

  @GET(API.stagerByEventAndTeamMember)
  Future<Stager> getStagerByEventAndTeamMember(
    @Query('eventId') String eventId,
    @Query('teamMemberId') String teamMemberId,
  );

  @GET(API.stagers)
  Future<List<Stager>> getStagersByEventAndPosition(
    @Query('eventId') String eventId,
    @Query('positionId') String positionId,
  );
}
