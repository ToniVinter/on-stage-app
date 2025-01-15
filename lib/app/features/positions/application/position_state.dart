import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';

part 'position_state.freezed.dart';

@freezed
class PositionState with _$PositionState {
  const factory PositionState({
    @Default([]) List<Position> positions,
    @Default(false) bool isLoading,
    @Default(null) String? error,
  }) = _PositionState;
}
