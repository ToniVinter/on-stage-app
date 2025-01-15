import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_notifier.dart';
import 'package:on_stage_app/app/features/groups/group_template/application/group_template_state.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/create_group_modal.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/widgets/groups_grid.dart';
import 'package:on_stage_app/app/shared/add_new_button.dart';
import 'package:on_stage_app/app/shared/stage_app_bar.dart';
import 'package:on_stage_app/app/shared/top_flush_bar.dart';

class GroupsScreen extends ConsumerStatefulWidget {
  const GroupsScreen({super.key});

  @override
  GroupsScreenState createState() => GroupsScreenState();
}

class GroupsScreenState extends ConsumerState<GroupsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(groupTemplateNotifierProvider.notifier).getGroupsTemplate();
    });
    super.initState();
  }

  void _setupErrorListener() {
    ref.listen<GroupTemplateState>(
      groupTemplateNotifierProvider,
      (previous, next) {
        if (next.error != null && mounted) {
          TopFlushBar.show(
            context,
            next.error.toString(),
            isError: true,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _setupErrorListener();

    return Scaffold(
      appBar: StageAppBar(
        title: 'Groups',
        isBackButtonVisible: true,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AddNewButton(
            onPressed: () {
              CreateGroupModal.show(context: context);
            },
          ),
        ),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref
              .read(groupTemplateNotifierProvider.notifier)
              .getGroupsTemplate();
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: GroupsTemplateGrid(),
        ),
      ),
    );
  }
}
