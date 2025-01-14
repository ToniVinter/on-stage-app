import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/domain/models/event_items/event_item.dart';
import 'package:on_stage_app/app/features/event_items/presentation/controllers/moment_state.dart';

final momentControllerProvider =
    StateNotifierProvider.family<MomentController, MomentState, EventItem>(
  (ref, moment) => MomentController(moment),
);

class MomentController extends StateNotifier<MomentState> {
  MomentController(EventItem moment) : super(MomentState.initial(moment));

  void toggleEditing() {
    state = state.copyWith(isEditing: !state.isEditing);
  }

  void updateContent(String title, String description) {
    state = state.copyWith(
      title: title,
      description: description,
    );
  }

  void saveChanges() {
    state = state.copyWith(
      isEditing: false,
      moment: state.moment.copyWith(
        name: state.title,
        description: state.description,
      ),
    );
  }

  void cancelEditing() {
    state = state.copyWith(
      isEditing: false,
      title: state.moment.name ?? '',
      description: state.moment.description ?? '',
    );
  }
}
