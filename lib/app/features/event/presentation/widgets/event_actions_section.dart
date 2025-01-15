import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/event_notifier.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/edit_date_modal.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/adaptive_dialog.dart';
import 'package:on_stage_app/app/shared/blue_action_button.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class EventActionsSection extends ConsumerWidget {
  const EventActionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        EventActionButton(
          onTap: () {
            DuplicateEventModal.show(context: context);
          },
          text: 'Duplicate Event',
          textColor: context.colorScheme.onSurface,
        ),
        const SizedBox(height: 16),
        EventActionButton(
          onTap: () {
            AdaptiveDialog.show(
              context: context,
              title: 'Delete Event',
              description: 'Are you sure you want to delete this event?',
              actionText: 'Delete',
              onAction: () async {
                await ref
                    .read(eventNotifierProvider.notifier)
                    .deleteEventAndGetAll();

                context.pushReplacementNamed(AppRoute.events.name);
              },
            );
          },
          text: 'Delete Event',
          textColor: context.colorScheme.error,
        ),
      ],
    );
  }
}
