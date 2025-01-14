import 'package:drift/drift.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/features/plan/domain/plan.dart';

class PlanTable extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get entitlementId => text()();

  TextColumn get appleProductId => text()();

  TextColumn get googleProductId => text()();

  RealColumn get price => real()();

  TextColumn get currency => text()();

  BoolColumn get isYearly => boolean()();

  IntColumn get maxEvents => integer()();

  IntColumn get maxMembers => integer()();

  BoolColumn get hasAddSong => boolean()();

  BoolColumn get hasScreensSync => boolean()();

  BoolColumn get hasReminders => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

extension PlanTableDataX on PlanTableData {
  Plan toPlan() {
    return Plan(
      id: id,
      name: name,
      entitlementId: entitlementId,
      appleProductId: appleProductId,
      googleProductId: googleProductId,
      price: price,
      currency: currency,
      isYearly: isYearly,
      maxEvents: maxEvents,
      maxMembers: maxMembers,
      hasAddSong: hasAddSong,
      hasScreensSync: hasScreensSync,
      hasReminders: hasReminders,
    );
  }
}

extension PlanX on Plan {
  PlanTableCompanion toTableCompanion() {
    return PlanTableCompanion.insert(
      id: id,
      name: name,
      entitlementId: entitlementId,
      appleProductId: appleProductId,
      googleProductId: googleProductId,
      price: price,
      currency: currency,
      isYearly: isYearly,
      maxEvents: maxEvents,
      maxMembers: maxMembers,
      hasAddSong: hasAddSong,
      hasScreensSync: hasScreensSync,
      hasReminders: hasReminders,
    );
  }
}
