import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/create_stager_request.dart';

part 'create_all_stagers_request.freezed.dart';
part 'create_all_stagers_request.g.dart';

@Freezed()
class CreateAllStagersRequest with _$CreateAllStagersRequest {
  const factory CreateAllStagersRequest({
    required String eventId,
    required List<CreateStagerRequest> stagers,
  }) = _CreateAllStagersRequest;

  factory CreateAllStagersRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAllStagersRequestFromJson(json);
}
