import 'package:freezed_annotation/freezed_annotation.dart';

part 'group_template.freezed.dart';
part 'group_template.g.dart';

@freezed
class GroupTemplateModel with _$GroupTemplateModel {
  const factory GroupTemplateModel({
    required String id,
    required String name,
    @Default(0) int? positionsCount,
  }) = _GroupTemplateModel;

  factory GroupTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$GroupTemplateModelFromJson(json);
}
