import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/providers/group_card_template_state.dart';
import 'package:on_stage_app/app/utils/string_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_card_template_provider.g.dart';

@riverpod
class GroupTemplate extends _$GroupTemplate {
  @override
  GroupCardTemplateState build(String groupId) {
    final groupState = ref.watch(groupTemplateNotifierProvider);

    if (groupState.isLoading) {
      return const GroupCardTemplateState(group: null);
    }

    try {
      final group = groupState.groups.firstWhere(
        (group) => group.id == groupId,
      );
      return GroupCardTemplateState(group: group);
    } catch (_) {
      // Return last known state if exists
      return const GroupCardTemplateState(group: null);
    }
  }

  void startEditing() {
    if (state.group == null) return;
    state = state.copyWith(isEditing: true);
  }

  void stopEditingAndSave(String newName) {
    if (newName.isNullEmptyOrWhitespace || state.group == null) {
      state = state.copyWith(isEditing: false);
      return;
    }

    ref
        .read(groupTemplateNotifierProvider.notifier)
        .updateGroup(state.group!.id, newName);
    state = state.copyWith(isEditing: false);
  }

  void deleteGroup() {
    if (state.group == null) return;

    ref
        .read(groupTemplateNotifierProvider.notifier)
        .deleteGroup(state.group!.id);
  }
}
