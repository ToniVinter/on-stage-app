import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/app_data/app_data_controller.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/presentation/controller/song_preferences_controller.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/add__structure_items_widget.dart';
import 'package:on_stage_app/app/features/song/presentation/preferences/widgets/reorder_list_widget.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class SongStructureModal extends ConsumerStatefulWidget {
  const SongStructureModal({
    super.key,
  });

  @override
  SongStructureModalState createState() => SongStructureModalState();

  static void show({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    showModalBottomSheet<Widget>(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => const SongStructureModal(),
    );
  }
}

class SongStructureModalState extends ConsumerState<SongStructureModal> {
  bool isOrderPage = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollModal(
      buildHeader: () => _buildHeader(context),
      buildFooter: () => _buildFooter(context),
      headerHeight: () {
        return 64;
      },
      footerHeight: () {
        return 64;
      },
      buildContent:
          isOrderPage ? ReorderListWidget.new : AddStructureItemsWidget.new,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          32,
        ),
        child: ref.watch(appDataControllerProvider).hasEditorsRight
            ? ContinueButton(
                text: isOrderPage ? 'Save' : 'Add',
                onPressed: () {
                  if (!isOrderPage) {
                    final newSections = ref
                        .watch(songPreferencesControllerProvider)
                        .songSections;
                    final existingSections =
                        ref.watch(songNotifierProvider).sections;
                    existingSections.addAll(newSections);
                    ref
                        .read(songNotifierProvider.notifier)
                        .updateSongSections(existingSections);
                    ref
                        .read(songPreferencesControllerProvider.notifier)
                        .resetSongSections();

                    setState(() {
                      isOrderPage = true;
                    });
                  } else {
                    final songId = ref.watch(songNotifierProvider).song.id;
                    final teamId =
                        ref.watch(teamNotifierProvider).currentTeam?.id;
                    final structure = ref
                        .watch(songNotifierProvider)
                        .sections
                        .map((e) => e.structure)
                        .toList();
                    ref
                        .read(songConfigurationNotifierProvider.notifier)
                        .updateSongConfiguration(
                          SongConfigRequest(
                            songId: songId,
                            teamId: teamId,
                            isCustom: true,
                            structure: structure,
                          ),
                        );

                    context.popDialog();
                  }
                },
                isEnabled: true,
              )
            : const SizedBox(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ModalHeader(
      leadingButton: ref.watch(appDataControllerProvider).hasEditorsRight
          ? SizedBox(
              width: 80 - 12,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isOrderPage = !isOrderPage;
                  });
                },
                child: _buildLeadingTile(context),
              ),
            )
          : const SizedBox(width: 80 - 12),
      title: 'Song Structure',
    );
  }

  Widget _buildLeadingTile(BuildContext context) {
    return isOrderPage
        ? SizedBox(
            child: Row(
              children: [
                const Icon(Icons.add, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'Add',
                  style: context.textTheme.titleMedium!
                      .copyWith(color: Colors.blue),
                ),
              ],
            ),
          )
        : Text(
            'Back',
            style: context.textTheme.titleMedium!.copyWith(
              color: const Color(0xFF828282),
            ),
          );
  }
}
