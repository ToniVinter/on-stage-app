import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';

class UpcomingEventEnhanced extends StatelessWidget {
  const UpcomingEventEnhanced({
    required this.title,
    required this.hour,
    required this.hasUpcomingEvent,
    this.location,
    super.key,
  });

  final String title;
  final String hour;
  final String? location;
  final bool hasUpcomingEvent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD8E1FE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: hasUpcomingEvent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Upcoming',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: Insets.medium),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.surface,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: Insets.medium),
                Row(
                  children: [
                    Text(
                      hour,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.surface,
                          ),
                    ),
                    _buildCircle(context),
                    Text(
                      "20 dec.",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: context.colorScheme.surface,
                          ),
                    ),
                  ],
                ),
                Text(
                  location ?? '',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: context.colorScheme.surface,
                      ),
                ),
                const Expanded(child: SizedBox()),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ParticipantsOnTile(
                      borderColor: Color(0xFFD8E1FE),
                      participantsProfile: [
                        'assets/images/profile1.png',
                        'assets/images/profile2.png',
                        'assets/images/profile4.png',
                        'assets/images/profile5.png',
                        'assets/images/profile5.png',
                        'assets/images/profile5.png',
                        'assets/images/profile5.png',
                        'assets/images/profile5.png',
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'No upcoming events',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Implement event creation functionality here
                    },
                    icon: Assets.icons.plus.svg(),
                    label: const Text(
                      'Create Event',
                      style: TextStyle(
                        color: Color(0xFF7366FF),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCircle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Icon(
        Icons.circle,
        size: 4,
        color: context.colorScheme.surface,
      ),
    );
  }
}
