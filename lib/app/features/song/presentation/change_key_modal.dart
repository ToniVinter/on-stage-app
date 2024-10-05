import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/features/lyrics/model/chord_enum.dart';
import 'package:on_stage_app/app/features/song/application/song/song_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/tonality/song_key.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/chord_type_widget.dart';
import 'package:on_stage_app/app/features/song_configuration/application/song_config_notifier.dart';
import 'package:on_stage_app/app/features/song_configuration/domain/song_config_request/song_config_request.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/shared/continue_button.dart';
import 'package:on_stage_app/app/shared/modal_header.dart';
import 'package:on_stage_app/app/shared/nested_scroll_modal.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class ChangeKeyModal extends ConsumerStatefulWidget {
  const ChangeKeyModal(
    this.songKey, {
    this.isFromEvent = false,
    super.key,
  });

  final SongKey songKey;
  final bool isFromEvent;

  @override
  ChangeKeyModalState createState() => ChangeKeyModalState();

  static void show({
    required BuildContext context,
    required SongKey songKey,
    bool isFromEvent = false,
  }) {
    showModalBottomSheet<Widget>(
      backgroundColor: context.colorScheme.surface,
      context: context,
      builder: (context) => NestedScrollModal(
        buildHeader: () => ModalHeader(
          title: isFromEvent ? 'Change Key' : 'Preview Key',
        ),
        headerHeight: () {
          return 64;
        },
        buildContent: () {
          return SingleChildScrollView(
            child: ChangeKeyModal(songKey, isFromEvent: isFromEvent),
          );
        },
      ),
    );
  }
}

class ChangeKeyModalState extends ConsumerState<ChangeKeyModal> {
  late SongKey _songKey;
  late SongKey _initialSongKey;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    _songKey = widget.songKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _songKey = ref.read(songNotifierProvider).song.key!;
        _initialSongKey = _songKey;
      });
    });
  }

  void _updateSongKey(SongKey newKey) {
    setState(() {
      _songKey = newKey;
      _hasChanged = _songKey != _initialSongKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildKeys(),
          const SizedBox(height: Insets.small),
          _buildChordTypes(_songKey.isSharp),
          const SizedBox(height: Insets.normal),
          ContinueButton(
            text: 'Save',
            onPressed: _submitForm,
            isEnabled: _hasChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildKeys() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Key',
              style: context.textTheme.titleSmall,
            ),
            Text(
              'Original ${ref.watch(songNotifierProvider).song.originalKey?.name}',
              style: context.textTheme.titleSmall!.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: Insets.small),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          height: 80,
          decoration: BoxDecoration(
            color: context.colorScheme.onSurfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: ChordsWithoutSharp.values.map((chord) {
              if (chord == _songKey.chord) {
                return _buildChordLabel(chord, isSelected: true);
              }
              return _buildChordLabel(chord);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildChordLabel(ChordsWithoutSharp chord, {bool isSelected = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _updateSongKey(_songKey.copyWith(chord: chord, isSharp: false));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.surface,
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(chord.name, style: _getStyling(isSelected: isSelected)),
        ),
      ),
    );
  }

  Widget _buildChordTypes(bool isSharp) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: context.colorScheme.onSurfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ChordTypeWidget(
            isEnabled: _getInactiveForEAndB(),
            chordType: 'natural',
            isSharp: _songKey.isSharp == false,
            onTap: () {
              _updateSongKey(_songKey.copyWith(isSharp: false));
            },
          ),
          ChordTypeWidget(
            chordType: '♯',
            isSharp: _songKey.isSharp == true,
            onTap: _getInactiveForEAndB()
                ? () {
                    _updateSongKey(_songKey.copyWith(isSharp: true));
                  }
                : () {},
          ),
        ],
      ),
    );
  }

  bool _getInactiveForEAndB() {
    return _songKey.chord!.name != ChordsWithoutSharp.E.name &&
        _songKey.chord!.name != ChordsWithoutSharp.B.name;
  }

  TextStyle _getStyling({bool isSelected = false}) {
    return context.textTheme.titleMedium!.copyWith(
      color: isSelected
          ? context.colorScheme.onSurfaceVariant
          : context.colorScheme.onSurface,
    );
  }

  Future<void> _submitForm() async {
    ref.read(songNotifierProvider.notifier).transpose(_songKey);
    if (widget.isFromEvent) await _updateSongOnDB();
    if (mounted) {
      context.popDialog();
    }
  }

  Future<void> _updateSongOnDB() async {
    final songId = ref.read(songNotifierProvider).song.id;
    final teamId = ref.read(teamNotifierProvider).currentTeam?.id;
    await ref
        .read(songConfigurationNotifierProvider.notifier)
        .updateSongConfiguration(
          SongConfigRequest(
            songId: songId,
            teamId: teamId,
            isCustom: true,
            key: _songKey,
          ),
        );
    unawaited(ref.read(songNotifierProvider.notifier).init(songId!));
  }
}
