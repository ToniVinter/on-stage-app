import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';

part 'group_template_state.freezed.dart';

@freezed
class GroupTemplateState with _$GroupTemplateState {
  const factory GroupTemplateState({
    @Default([]) List<GroupTemplateModel> groups,
    @Default(false) bool isLoading,
    Object? error,
  }) = _GroupTemplateState;
}
