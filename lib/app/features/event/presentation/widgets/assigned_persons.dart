import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager.dart';
import 'package:on_stage_app/app/features/event/presentation/widgets/participants_on_tile.dart';
import 'package:on_stage_app/app/shared/adaptive_menu_context.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class AssignedPersons extends StatelessWidget {
  const AssignedPersons({required this.stagers, this.isSong = true, super.key});

  final List<Stager> stagers;
  final bool isSong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          SizedBox(
            width: stagers.length > 1 ? 52 : 32,
            child: ParticipantsOnTile(
              participantsProfileBytes: [],
              participantsProfile: stagers.map((e) => e.name ?? '').toList(),
              participantsLength: stagers.length,
              width: 24,
            ),
          ),
          if (stagers.length > 1 && isSong)
            AdaptiveMenuContext(
              items: stagers
                  .map(
                    (e) => MenuAction(
                      title: e.name ?? '',
                      onTap: () {
                        logger.d('Tapped on ${e.name}');
                      },
                    ),
                  )
                  .toList(),
              child: const Row(
                children: [
                  Text('Lead Vocalist'),
                  SizedBox(width: 4),
                  Icon(
                    LucideIcons.chevron_down,
                    size: 16,
                  )
                ],
              ),
            )
          else if (stagers.length == 1 || !isSong)
            Text(
              stagers.first.name ?? '',
              style: context.textTheme.bodyMedium!.copyWith(),
            ),
        ],
      ),
    );
  }
}
