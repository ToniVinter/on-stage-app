import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';

part 'position_card_state.freezed.dart';

@freezed
class PositionCardState with _$PositionCardState {
  const factory PositionCardState({
    required Position? position,
    @Default(false) bool isEditing,
  }) = _PositionCardState;
}
