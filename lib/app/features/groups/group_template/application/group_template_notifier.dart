import 'package:dio/dio.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_state.dart';
import 'package:on_stage_app/app/features/groups/group_template/data/group_template_repository.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/create_or_edit_group_request.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/app/shared/data/enums/error_type.dart';
import 'package:on_stage_app/app/shared/data/error_model/error_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_template_notifier.g.dart';

@riverpod
class GroupTemplateNotifier extends _$GroupTemplateNotifier {
  GroupTemplateRepository? _groupRepository;

  GroupTemplateRepository get groupRepository {
    _groupRepository ??= GroupTemplateRepository(ref.watch(dioProvider));
    return _groupRepository!;
  }

  @override
  GroupTemplateState build() {
    final dio = ref.watch(dioProvider);
    _groupRepository = GroupTemplateRepository(dio);
    return const GroupTemplateState();
  }

  Future<void> getGroupsTemplate() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final groups = await groupRepository.getGroupsTemplate();
      state = state.copyWith(groups: groups);
    } catch (e) {
      state = state.copyWith(error: e);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getGroupTemplate(String id) async {
    try {
      state = state.copyWith(error: null);
      final group = await groupRepository.getGroupTemplate(id);
      final updatedList =
          state.groups.map((e) => e.id == id ? group : e).toList();
      state = state.copyWith(groups: updatedList);
    } catch (e) {
      state = state.copyWith(error: e);
    }
  }

  Future<void> createGroup(String title) async {
    state = state.copyWith(error: null);

    try {
      final newGroup = await groupRepository.createGroup(
        CreateOrEditGroupRequest(
          name: title,
        ),
      );
      state = state.copyWith(
        groups: [...state.groups, newGroup],
      );
    } on DioException catch (e) {
      String? errorMessage;
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorModel = ApiErrorResponse.fromJson(errorData);
        if (errorModel.errorName == ErrorType.DUPLICATE_GROUP_NAME) {
          errorMessage = errorModel.errorName
              ?.getDescription('User with email or username');
        }
      }
      state = state.copyWith(
        error: errorMessage ?? e.message,
      );
    }
  }

  Future<void> updateGroup(String id, String newName) async {
    try {
      state = state.copyWith(error: null);
      _updateLocally(id, newName);
      await groupRepository.updateGroup(
        id,
        CreateOrEditGroupRequest(name: newName),
      );
    } on DioException catch (e) {
      String? errorMessage;
      if (e.response != null && e.response!.data is Map<String, dynamic>) {
        final errorData = e.response!.data as Map<String, dynamic>;
        final errorModel = ApiErrorResponse.fromJson(errorData);
        if (errorModel.errorName == ErrorType.DUPLICATE_GROUP_NAME) {
          errorMessage = errorModel.errorName?.getDescription('Group');
        }
      }

      state = state.copyWith(
        error: errorMessage ?? e.message,
      );
      await getGroupsTemplate();
    }
  }

  Future<void> deleteGroup(String id) async {
    state = state.copyWith(error: null);
    final previousGroups = [...state.groups];

    try {
      await groupRepository.deleteGroup(id);

      state = state.copyWith(
        groups: state.groups.where((group) => group.id != id).toList(),
      );
    } catch (e) {
      state = state.copyWith(
        groups: previousGroups,
        error: e.toString(),
      );

      await getGroupsTemplate();
    }
  }

  void _updateLocally(String id, String newName) {
    state = state.copyWith(
      groups: state.groups.map((group) {
        if (group.id == id) {
          return group.copyWith(name: newName);
        }
        return group;
      }).toList(),
    );
  }
}
