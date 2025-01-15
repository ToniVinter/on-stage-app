import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';

part 'stager.freezed.dart';
part 'stager.g.dart';

@Freezed()
class Stager with _$Stager {
  const factory Stager({
    required String id,
    required String? name,
    required StagerStatusEnum? participationStatus,
    required String? userId,
    String? groupId,
    String? positionId,
    @JsonKey(includeFromJson: false) Uint8List? profilePicture,
  }) = _Stager;

  factory Stager.fromJson(Map<String, dynamic> json) => _$StagerFromJson(json);
}
