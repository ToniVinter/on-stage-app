import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';

part 'moment_state.freezed.dart';

@freezed
class MomentState with _$MomentState {
  const factory MomentState({
    required EventItem moment,
    required bool isEditing,
    required String title,
    required String description,
  }) = _MomentState;

  factory MomentState.initial(EventItem moment) => MomentState(
        moment: moment,
        isEditing: false,
        title: moment.name ?? '',
        description: moment.name ?? '',
      );
}
