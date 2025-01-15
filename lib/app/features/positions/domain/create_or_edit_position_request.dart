import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_or_edit_position_request.freezed.dart';
part 'create_or_edit_position_request.g.dart';

@freezed
class CreateOrEditPositionRequest with _$CreateOrEditPositionRequest {
  const factory CreateOrEditPositionRequest({
    required String name,
    String? groupId,
  }) = _CreateOrEditPositionRequest;

  factory CreateOrEditPositionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrEditPositionRequestFromJson(json);
}
