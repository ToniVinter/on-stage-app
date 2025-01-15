import 'package:flutter/material.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class TeamListTile extends StatelessWidget {
  const TeamListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        title: Text(
          'Echipa Racheta',
          style: context.textTheme.headlineMedium,
        ),
        subtitle: Text(
          '4 Members',
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        trailing: const ParticipantsOnTile(
          participantsProfileName: [
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
        onTap: () {
          context.pushNamed(AppRoute.teamDetails.name);
        },
      ),
    );
  }
}
