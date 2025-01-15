// position_notifier.dart

import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/positions/application/position_state.dart';
import 'package:on_stage_app/app/features/positions/data/position_template_repository.dart';
import 'package:on_stage_app/app/features/positions/domain/create_or_edit_position_request.dart';
import 'package:on_stage_app/app/features/positions/domain/position.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/error_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'position_notifier.g.dart';

@riverpod
class PositionNotifier extends _$PositionNotifier {
  PositionTemplateRepository get _repository =>
      ref.read(positionRepositoryProvider);

  @override
  PositionState build() {
    return const PositionState();
  }

  Future<void> getPositions(String groupId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final positions = await _repository.getPositionsTemplate(groupId);

      state = state.copyWith(
        positions: positions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> addPosition(String positionName, String groupId) async {
    state = state.copyWith(error: null);
    try {
      final position = await _repository.addPosition(
        CreateOrEditPositionRequest(name: positionName, groupId: groupId),
      );

      final updatedPositions = [...state.positions, position];
      state = state.copyWith(
        positions: updatedPositions,
        error: null,
      );
    } on DioException catch (e) {
      String? errorMessage;
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorModel = ApiErrorResponse.fromJson(errorData);
        if (errorModel.errorName == ErrorType.DUPLICATE_POSITION_NAME) {
          errorMessage = errorModel.errorName
              ?.getDescription('User with email or username');
        } else if (errorModel.errorName ==
            ErrorType.TEAM_MEMBER_ALREADY_EXISTS) {
          errorMessage = errorModel.errorName
              ?.getDescription('User with email or username');
        }
      }
      state = state.copyWith(
        error: errorMessage ?? e.message,
      );
    }
  }

  Future<void> updatePosition(String newName, String positionId) async {
    state = state.copyWith(error: null);
    final previousPositions = state.positions;

    try {
      final updatedList = state.positions.map((position) {
        if (position.id == positionId) {
          return position.copyWith(name: newName);
        }
        return position;
      }).toList();

      state = state.copyWith(positions: updatedList);

      await _repository.updatePosition(
        positionId,
        CreateOrEditPositionRequest(name: newName),
      );
    } catch (e) {
      state = state.copyWith(
        positions: previousPositions,
        error: e is DioException ? e.message : e.toString(),
      );
      rethrow;
    }
  }

  Future<void> deletePosition(String positionId) async {
    state = state.copyWith(error: null);
    final previousPositions = state.positions;

    try {
      final updatedPositions = state.positions
          .where((position) => position.id != positionId)
          .toList();

      state = state.copyWith(positions: updatedPositions);

      await _repository.deletePosition(positionId);
    } catch (e) {
      state = state.copyWith(
        positions: previousPositions,
        error: e is DioException ? e.message : e.toString(),
      );
    }
  }

  Position? getPositionById(String id) {
    state = state.copyWith(error: null);
    try {
      return state.positions.firstWhere(
        (position) => position.id == id,
      );
    } catch (e) {
      return null;
    }
  }
}
