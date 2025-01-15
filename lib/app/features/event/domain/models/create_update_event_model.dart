import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/event/domain/enums/event_status_enum.dart';
import 'package:on_stage_app/app/features/event/domain/models/rehearsal/rehearsal_model.dart';

part 'create_update_event_model.freezed.dart';
part 'create_update_event_model.g.dart';

@Freezed()
class CreateUpdateEventModel with _$CreateUpdateEventModel {
  const factory CreateUpdateEventModel({
    String? name,
    DateTime? dateTime,
    String? location,
    EventStatus? eventStatus,
    List<RehearsalModel>? rehearsals,
    List<String>? teamMemberIds,
    @Default(true) bool? containsGroups,
  }) = _CreateUpdateEventModel;

  factory CreateUpdateEventModel.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateEventModelFromJson(json);
}
