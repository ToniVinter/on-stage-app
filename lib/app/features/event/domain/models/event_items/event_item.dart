import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event_items/domain/event_item_type.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_overview_model.dart';
import 'package:on_stage_app/app/utils/time_utils.dart';

part 'event_item.freezed.dart';
part 'event_item.g.dart';

@Freezed()
class EventItem with _$EventItem {
  const factory EventItem({
    String? id,
    String? name,
    String? description,
    int? index,
    EventItemType? eventType,
    SongOverview? song,
    String? eventId,
    // to be renamed into assignedTo
    @Default([]) List<Stager>? leadVocals,
    @Default(Duration.zero) Duration? duration,
  }) = _EventItem;

  const EventItem._();

  factory EventItem.fromSong(SongOverview song, int index) => EventItem(
        name: song.title,
        index: index,
        song: song,
        eventType: EventItemType.song,
      );

  factory EventItem.fromMoment(
    String momentName,
    int index, [
    String? description,
  ]) =>
      EventItem(
        name: momentName,
        index: index,
        eventType: EventItemType.other,
        description: description,
      );

  factory EventItem.fromJson(Map<String, dynamic> json) =>
      _$EventItemFromJson(json);

  String getTime(DateTime startTime) {
    final updatedTime = startTime.add(duration ?? Duration.zero);
    return TimeUtils().formatOnlyTime(updatedTime);
  }
}
