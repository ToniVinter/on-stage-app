import 'package:equatable/equatable.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_overview_model.dart';

class EventState extends Equatable {
  const EventState({
    this.events = const [],
    this.pastEvents = const [],
    this.upcomingEvents = const [],
    this.thisWeekEvents = const [],
    this.filteredEvents = const [],
  });

  final List<EventOverview> events;
  final List<EventOverview> pastEvents;
  final List<EventOverview> upcomingEvents;
  final List<EventOverview> thisWeekEvents;
  final List<EventOverview> filteredEvents;

  @override
  List<Object?> get props => events;

  EventState copyWith({
    List<EventOverview>? events,
    List<EventOverview>? pastEvents,
    List<EventOverview>? upcomingEvents,
    List<EventOverview>? thisWeekEvents,
    List<EventOverview>? filteredEvents,
  }) {
    return EventState(
      events: events ?? this.events,
      pastEvents: pastEvents ?? this.pastEvents,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      thisWeekEvents: thisWeekEvents ?? this.thisWeekEvents,
      filteredEvents: filteredEvents ?? this.filteredEvents,
    );
  }
}
