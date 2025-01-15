import 'package:on_stage_app/app/features/groups/group_event/application/group_event_state.dart';
import 'package:on_stage_app/app/features/groups/group_event/data/group_event_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_event_notifier.g.dart';

@riverpod
class GroupEventNotifier extends _$GroupEventNotifier {
  GroupEventRepository get _groupEventRepo => ref.read(groupEventRepoProvider);

  @override
  GroupEventState build() {
    return const GroupEventState();
  }

  Future<void> getGroupsEvent(String eventId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final groups = await _groupEventRepo.getGroups(eventId);
      state = state.copyWith(groupEvents: groups);
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getGroupEventById(String eventId, String groupId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final group = await _groupEventRepo.getGroupById(eventId, groupId);
      final updatedList =
          state.groupEvents.map((e) => e.id == groupId ? group : e).toList();
      state = state.copyWith(groupEvents: updatedList);
    } catch (e) {
      state = state.copyWith(error: e);
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
