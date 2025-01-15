import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_event.freezed.dart';
part 'group_event.g.dart';

@freezed
class GroupEvent with _$GroupEvent {
  const factory GroupEvent({
    required String id,
    required String name,
    @Default(0) int membersCount,
    @Default(0) int confirmedCount,
    @Default([]) List<String>? stagersWithPhoto,
  }) = _GroupEvent;

  factory GroupEvent.fromJson(Map<String, dynamic> json) =>
      _$GroupEventFromJson(json);
}
