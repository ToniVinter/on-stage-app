import 'package:on_stage_app/app/features/positions/application/position_notifier.dart';
import 'package:on_stage_app/app/features/positions/providers/position_card_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position_card_provider.g.dart';

@riverpod
class PositionCard extends _$PositionCard {
  @override
  PositionCardState build(String positionId) {
    final positionState = ref.watch(positionNotifierProvider);

    if (positionState.isLoading) {
      return const PositionCardState(position: null);
    }

    try {
      final position = positionState.positions.firstWhere(
        (position) => position.id == positionId,
      );
      return PositionCardState(position: position);
    } catch (_) {
      return const PositionCardState(position: null);
    }
  }

  void startEditing() {
    if (state.position == null) return;

    state = state.copyWith(isEditing: true);
  }

  void stopEditingAndSave(String newName) {
    if (newName.isEmpty || state.position == null) return;

    final positionId = state.position!.id;
    ref
        .read(positionNotifierProvider.notifier)
        .updatePosition(newName, positionId);
    state = state.copyWith(isEditing: false);
  }

  void deletePosition() {
    if (state.position == null) return;
    ref.read(positionNotifierProvider.notifier).deletePosition(positionId);
  }
}
