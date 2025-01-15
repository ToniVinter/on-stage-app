import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';

part 'event_controller_state.freezed.dart';

@freezed
class EventControllerState with _$EventControllerState {
  const factory EventControllerState({
    @Default([]) List<String> selectedTeamMemberIds,
    @Default([]) List<SongOverview> songs,
    @Default([]) List<String> moments,
    @Default([]) List<EventItem> eventItems,
    @Default('') String eventName,
    @Default('') String eventLocation,
    DateTime? dateTime,
  }) = _EventControllerState;
}
