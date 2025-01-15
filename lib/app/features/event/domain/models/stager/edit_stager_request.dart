import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

part 'edit_stager_request.freezed.dart';
part 'edit_stager_request.g.dart';

@Freezed()
class EditStagerRequest with _$EditStagerRequest {
  const factory EditStagerRequest({
    String? userId,
    String? name,
    StagerStatusEnum? participationStatus,
    @JsonKey(includeFromJson: false) Uint8List? profilePicture,
  }) = _EditStagerRequest;

  factory EditStagerRequest.fromJson(Map<String, dynamic> json) =>
      _$EditStagerRequestFromJson(json);
}
