// import 'package:on_stage_app/app/features/groups/application/group_notifier.dart';
// import 'package:on_stage_app/app/features/groups/presentation/providers/group_card_state.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
// part 'group_card_provider.g.dart';
//
// @riverpod
// class GroupCard extends _$GroupCard {
//   @override
//   GroupCardState build(String groupId) {
//     return GroupCardState(
//       group: ref.watch(groupNotifierProvider).groups.firstWhere(
//             (group) => group.id == groupId,
//             orElse: () => throw StateError('Group not found: $groupId'),
//           ),
//     );
//   }
//
//   void startEditing() {
//     state = state.copyWith(isEditing: true);
//   }
//
//   void stopEditingAndSave(String newTitle) {
//     if (newTitle.isEmpty) return;
//
//     final updatedGroup = state.group.copyWith(title: newTitle);
//     ref.read(groupNotifierProvider.notifier).updateGroup(updatedGroup);
//     state = state.copyWith(isEditing: false);
//   }
//
//   void deleteGroup() {
//     ref.read(groupNotifierProvider.notifier).deleteGroup(state.group.id);
//   }
// }
