import 'package:on_stage_app/app/dummy_data/participants_dummy.dart';
import 'package:on_stage_app/app/features/event/application/event/event_state.dart';
import 'package:on_stage_app/app/features/event/data/events_repository.dart';
import 'package:on_stage_app/app/features/event/domain/models/create_event_model.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_notifier.g.dart';

@Riverpod(keepAlive: true)
class EventNotifier extends _$EventNotifier {
  late final EventsRepository _eventsRepository;

  @override
  EventState build() {
    final dio = ref.read(dioProvider);
    _eventsRepository = EventsRepository(dio);
    return const EventState();
  }

  Future<void> init() async {
    if (state.event != null) {
      return;
    }
    logger.i('init event provider state');
  }

  Future<void> getEventById(String eventId) async {
    state = state.copyWith(isLoading: true);
    final event = await _eventsRepository.getEventById(eventId);

    state = state.copyWith(event: event, isLoading: false);
    // await getPlaylist();
  }

  Future<void> getPlaylist() async {
    if (state.playlist.isNotEmpty) {
      state = state.copyWith(playlist: state.playlist);
      return;
    }
    state = state.copyWith(isLoading: true);
    final playlist = [];
    state = state.copyWith(playlist: [], isLoading: false);
  }

  Future<void> getStagers() async {
    state = state.copyWith(isLoading: true);
    final stagers = StagersDummy.stagers;
    state = state.copyWith(stagers: stagers, isLoading: false);
  }

  Future<void> addEvent(CreateEventModel createdEvent) async {
    state = state.copyWith(isLoading: true);
    await _eventsRepository.createEvent(createdEvent);
    state = state.copyWith(isLoading: false);
  }

  Future<void> updateEvent() async {
    state = state.copyWith(isLoading: true);
    // await _eventsRepository.updateEvent(state.event!.id, updatedEvent);
    await _eventsRepository.updateEvent(
      '65d8a5138ae10c121bcc37d5',
      const EventModel(
        id: '65d8a5138ae10c121bcc37d5',
        name: null,
        date: null,
        rehearsalDates: null,
        eventItems: null,
        location: 'NOUA MEA LOCATIE',
      ),
    );
    state = state.copyWith(isLoading: false);
  }
}
