import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_or_edit_group_request.freezed.dart';
part 'create_or_edit_group_request.g.dart';

@freezed
class CreateOrEditGroupRequest with _$CreateOrEditGroupRequest {
  const factory CreateOrEditGroupRequest({
    required String name,
  }) = _CreateOrEditGroupRequest;

  factory CreateOrEditGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrEditGroupRequestFromJson(json);
}
