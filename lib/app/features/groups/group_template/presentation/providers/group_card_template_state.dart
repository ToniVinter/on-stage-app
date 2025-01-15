import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/groups/group_template/domain/group_template.dart';

part 'group_card_template_state.freezed.dart';

@freezed
class GroupCardTemplateState with _$GroupCardTemplateState {
  const factory GroupCardTemplateState({
    required GroupTemplateModel? group,
    @Default(false) bool isEditing,
  }) = _GroupCardTemplateState;
}
