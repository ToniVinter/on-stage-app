import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:on_stage_app/app/features/event/domain/models/stager/stager_status_enum.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/image_with_placeholder.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ParticipantListingItem extends StatelessWidget {
  const ParticipantListingItem({
    required this.name,
    required this.userId,
    required this.photo,
    required this.onDelete,
    this.status,
    this.trailing,
    this.canEdit = true,
    super.key,
  });

  final String name;
  final String userId;
  final Uint8List? photo;
  final StagerStatusEnum? status;
  final Widget? trailing;
  final VoidCallback onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Slidable(
        enabled: canEdit,
        key: ValueKey(name),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.3,
          dismissible: DismissiblePane(onDismissed: onDelete),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              label: 'Delete',
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            dense: true,
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            leading: ImageWithPlaceholder(
              photo: photo,
              name: name,
            ),
            title: Text(
              name,
              style: context.textTheme.titleMedium,
            ),
            trailing: trailing ??
                (status != null && status != StagerStatusEnum.UNINVINTED
                    ? _statusIcon(context, status)
                    : null),
            splashColor: context.colorScheme.outline.withOpacity(0.1),
            onTap: userId.isEmpty
                ? null
                : () {
                    context.pushNamed(
                      AppRoute.userProfileInfo.name,
                      queryParameters: {
                        'userId': userId,
                      },
                    );
                  },
          ),
        ),
      ),
    );
  }

  Widget _statusIcon(BuildContext context, StagerStatusEnum? status) {
    if (status == null) {
      return const SizedBox();
    }

    switch (status) {
      case StagerStatusEnum.CONFIRMED:
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      case StagerStatusEnum.PENDING:
        return Icon(
          Icons.check_circle,
          color: context.colorScheme.surfaceContainer,
        );
      case StagerStatusEnum.DECLINED:
        return Icon(
          Icons.cancel,
          color: context.colorScheme.error,
        );
      case StagerStatusEnum.UNINVINTED:
        return const SizedBox();
    }
  }
}
