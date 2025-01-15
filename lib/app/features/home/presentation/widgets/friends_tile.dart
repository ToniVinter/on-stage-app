import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class FriendsTile extends StatelessWidget {
  const FriendsTile({
    required this.numberOfFriends,
    super.key,
  });

  final int numberOfFriends;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Friends',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: context.colorScheme.surface,
                    ),
                maxLines: 1,
              ),
              const Spacer(),
              SizedBox(
                width: 16,
                child: Text(
                  numberOfFriends.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.surface,
                      ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        // const Expanded(child: SizedBox()),
        Row(
          children: [
            const ParticipantsOnTile(
              width: 24,
              participantsProfileName: [
                'assets/images/profile1.png',
                'assets/images/profile2.png',
                'assets/images/profile4.png',
              ],
            ),
            const Expanded(child: SizedBox()),
            InkWell(
              child: Icon(
                Icons.arrow_forward_ios,
                size: 24,
                color: context.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
