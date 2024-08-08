import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event/application/event/controller/event_controller.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddSongsModal extends ConsumerStatefulWidget {
  const AddSongsModal({super.key});

  @override
  AddSongsModalState createState() => AddSongsModalState();

  static void show({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
        minHeight: MediaQuery.of(context).size.height * 0.7,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      context: context,
      builder: (context) => NestedScrollModal(
        buildFooter: () => SizedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              32,
            ),
            child: Consumer(
              builder: (context, ref, _) {
                return ContinueButton(
                  hasShadow: true,
                  text: 'Add',
                  onPressed: () {
                    ref
                        .read(eventControllerProvider.notifier)
                        .addSelectedSongsToEventItems();
                    context.popDialog();
                  },
                  isEnabled: true,
                );
              },
            ),
          ),
        ),
        buildHeader: () => const ModalHeader(title: 'Add Songs'),
        headerHeight: () {
          return 64;
        },
        footerHeight: () {
          return 64;
        },
        buildContent: AddSongsModal.new,
      ),
    );
  }
}

class AddSongsModalState extends ConsumerState<AddSongsModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          StageSearchBar(
            focusNode: FocusNode(),
            controller: _searchController,
            onClosed: _clearSearch,
            onChanged: (value) {
              ref
                  .read(songsNotifierProvider.notifier)
                  .searchSongs(searchedText: value);
            },
          ),
          const SizedBox(height: 12),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ref.watch(songsNotifierProvider).songs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    if (_isItemChecked(index)) {
                      _removeSong(index);
                    } else {
                      _addSong(index);
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: context.colorScheme.onSurfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isItemChecked(index)
                          ? context.colorScheme.primary
                          : context.colorScheme.onSurfaceVariant,
                      width: 1.6,
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref
                                      .read(songsNotifierProvider)
                                      .songs
                                      .elementAt(index)
                                      .title ??
                                  '',
                              style: context.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Text(
                                  ref
                                          .read(songsNotifierProvider)
                                          .songs
                                          .elementAt(index)
                                          .artist
                                          ?.fullName ??
                                      '',
                                  style: context.textTheme.titleSmall,
                                ),
                                SongKeyLabelWidget(
                                  songKey: ref
                                          .read(songsNotifierProvider)
                                          .songs
                                          .elementAt(index)
                                          .key ??
                                      '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          _isItemChecked(index)
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          size: 20,
                          color: _isItemChecked(index)
                              ? context.colorScheme.primary
                              : context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addSong(int index) {
    ref.read(eventControllerProvider.notifier).addSong(
          ref.read(songsNotifierProvider).songs.elementAt(index),
        );
  }

  void _removeSong(int index) {
    ref.read(eventControllerProvider.notifier).removeSong(
          ref.read(songsNotifierProvider).songs.elementAt(index),
        );
  }

  void _clearSearch() {
    _searchController.clear();
  }

  bool _isItemChecked(int index) =>
      ref.watch(eventControllerProvider).songs.contains(
            ref.read(songsNotifierProvider).songs.elementAt(index),
          );
}
