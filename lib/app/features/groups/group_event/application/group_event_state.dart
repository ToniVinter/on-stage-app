import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/group_event/domain/group_event.dart';

part 'group_event_state.freezed.dart';

@freezed
class GroupEventState with _$GroupEventState {
  const factory GroupEventState({
    @Default([]) List<GroupEvent> groupEvents,
    @Default(false) bool isLoading,
    Object? error,
  }) = _GroupEventState;
}
