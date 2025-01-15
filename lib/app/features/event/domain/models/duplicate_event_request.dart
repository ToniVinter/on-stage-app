import 'package:freezed_annotation/freezed_annotation.dart';

part 'duplicate_event_request.freezed.dart';
part 'duplicate_event_request.g.dart';

@Freezed()
class DuplicateEventRequest with _$DuplicateEventRequest {
  const factory DuplicateEventRequest({
    required String? name,
    required String? dateTime,
    @Default(true) bool containsGroups,
  }) = _DuplicateEventRequest;

  factory DuplicateEventRequest.fromJson(Map<String, dynamic> json) =>
      _$DuplicateEventRequestFromJson(json);
}
