import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/notifications/presentation/widgets/notification_list.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/theme/theme.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getNotifications();
      unawaited(
        ref
            .read(notificationNotifierProvider.notifier)
            .markNotificationsAsViewed(),
      );
    });
  }

  Future<void> _getNotifications() async {
    await ref.read(notificationNotifierProvider.notifier).getNotifications();
  }

  Future<void> _refreshNotifications() async {
    await _getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StageAppBar(
        isBackButtonVisible: true,
        title: 'Notifications',
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: _refreshNotifications,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: defaultScreenHorizontalPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const NotificationList(),
                  childCount: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
