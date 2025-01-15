import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/event_items/application/controller/event_item_songs_controller.dart';
import 'package:on_stage_app/app/features/event_items/application/event_items_notifier.dart';
import 'package:on_stage_app/app/features/search/application/search_notifier.dart';
import 'package:on_stage_app/app/features/search/presentation/stage_search_bar.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/shared/song_key_label_widget.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class AddSongsModal extends ConsumerStatefulWidget {
  const AddSongsModal({required this.onSongsAdded, super.key});

  final VoidCallback onSongsAdded;

  @override
  AddSongsModalState createState() => AddSongsModalState();

  static void show({
    required BuildContext context,
    required VoidCallback onSongsAdded,
  }) {
    showModalBottomSheet<Widget>(
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surfaceContainerHigh,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.95,
        minHeight: MediaQuery.of(context).size.height * 0.95,
        maxWidth: context.isLargeScreen
            ? context.screenSize.width * 0.5
            : double.infinity,
      ),
      context: context,
      builder: (context) => NestedScrollModal(
        buildFooter: () => SizedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Consumer(
              builder: (context, ref, _) {
                final selectedSongs =
                    ref.watch(eventItemSongsControllerProvider).songs;
                return ContinueButton(
                  text: 'Add',
                  onPressed: selectedSongs.isNotEmpty
                      ? () {
                          ref
                              .read(eventItemsNotifierProvider.notifier)
                              .addSelectedSongsToEventItemsCache(selectedSongs);
                          onSongsAdded();
                          context.popDialog();
                        }
                      : () {},
                  isEnabled: selectedSongs.isNotEmpty,
                );
              },
            ),
          ),
        ),
        buildHeader: () => const ModalHeader(title: 'Add Songs'),
        headerHeight: () => 64,
        footerHeight: () => 64,
        buildContent: () => AddSongsModal(onSongsAdded: onSongsAdded),
      ),
    );
  }
}

class AddSongsModalState extends ConsumerState<AddSongsModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(songsNotifierProvider.notifier).getSongs();
    });
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
              final searchState = ref.watch(searchNotifierProvider);
              final songFilter = searchState.toSongFilter();
              ref.read(searchNotifierProvider.notifier).setText(value);
              ref.read(songsNotifierProvider.notifier).getSongs(
                    songFilter: songFilter.copyWith(
                      search: value,
                    ),
                  );
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
                      Flexible(
                        child: Padding(
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
                                  Flexible(
                                    child: Text(
                                      ref
                                              .read(songsNotifierProvider)
                                              .songs
                                              .elementAt(index)
                                              .artist
                                              ?.name ??
                                          '',
                                      style: context.textTheme.titleSmall,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SongKeyLabelWidget(
                                    songKey: ref
                                            .read(songsNotifierProvider)
                                            .songs
                                            .elementAt(index)
                                            .key
                                            ?.name ??
                                        '',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const Spacer(),
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
    ref.read(eventItemSongsControllerProvider.notifier).addSong(
          ref.read(songsNotifierProvider).songs.elementAt(index),
        );
  }

  void _removeSong(int index) {
    ref.read(eventItemSongsControllerProvider.notifier).removeSong(
          ref.read(songsNotifierProvider).songs.elementAt(index),
        );
  }

  void _clearSearch() {
    _searchController.clear();
  }

  bool _isItemChecked(int index) =>
      ref.watch(eventItemSongsControllerProvider).songs.contains(
            ref.read(songsNotifierProvider).songs.elementAt(index),
          );
}
