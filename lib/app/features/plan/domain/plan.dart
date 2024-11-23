import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:on_stage_app/app/features/plan/domain/plan_feature.dart';

part 'plan.freezed.dart';
part 'plan.g.dart';

@Freezed()
class Plan with _$Plan {
  const factory Plan({
    required String id,
    required String name,
    required String entitlementId,
    required String appleProductId,
    required String googleProductId,
    @Default(0) double price,
    @Default('RON') String currency,
    @Default(false) bool isYearly,
    @Default(0) int maxEvents,
    @Default(0) int maxMembers,
    @Default(false) bool hasAddSong,
    @Default(false) bool hasScreensSync,
    @Default(false) bool hasReminders,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}

extension PlanFeatures on Plan {
  List<PlanFeature> get features {
    return [
      const PlanFeature('Full Access to our Songs', true),
      PlanFeature('Create $maxEvents Events per month', true),
      PlanFeature('$maxMembers Members', true),
      PlanFeature('Add Your Own Songs', hasAddSong),
      PlanFeature('Add Reminders for Events', hasReminders),
      PlanFeature('Sync Screens with your Team', hasScreensSync),
    ];
  }
}
