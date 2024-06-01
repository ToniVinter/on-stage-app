import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_stage_app/app/dummy_data/song_dummy.dart';
import 'package:on_stage_app/app/features/event/application/events/events_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/group_tile.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/saved_songs_tiled.dart';
import 'package:on_stage_app/app/features/home/presentation/widgets/upcoming_event_enhanced.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/song/application/songs/songs_notifier.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model.dart';
import 'package:on_stage_app/app/features/song/presentation/widgets/stage_search_bar.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/app/shared/profile_image_inbox_widget.dart';
import 'package:on_stage_app/app/shared/song_tile.dart';
import 'package:on_stage_app/resources/generated/assets.gen.dart';
import 'package:on_stage_app/app/theme/theme.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  List<SongModel> _songs = List.empty(growable: true);
  final FocusNode _focusNode = FocusNode();
  final hasUpcomingEvent = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeNotifiers();
    });
  }

  void initializeNotifiers() {
    ref.read(songsNotifierProvider.notifier).init();
    ref.read(notificationNotifierProvider.notifier).getNotifications();
    ref.read(eventsNotifierProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: Insets.large),
            _buildSearchBar(),
            const SizedBox(height: Insets.large),
            _buildEnhanced(hasUpcomingEvent),
            const SizedBox(height: Insets.extraLarge),
            Padding(
              padding: defaultScreenHorizontalPadding,
              child: Text(
                'Upcoming events',
                style: context.textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: Insets.large),
            _buildRecentlyAdded(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyAdded() {
    // final songs = ref.watch(songsNotifierProvider).songs;
    _songs = SongDummy.playlist;
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          final song = _songs[index];
          return Column(
            children: [
              SongTile(
                song: song,
              ),
              Divider(
                color: context.colorScheme.outlineVariant,
                thickness: 1,
                height: Insets.medium,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: defaultScreenHorizontalPadding,
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: 'searchBar',
              child: StageSearchBar(
                focusNode: _focusNode,
                onTap: () => context.pushNamed(AppRoute.songs.name),
              ),
            ),
          ),
          const SizedBox(
            width: Insets.smallNormal,
          ),
          IconButton(
            onPressed: () => {context.pushNamed(AppRoute.notification.name)},
            icon: Stack(
              children: [
                Assets.icons.filledNotificationBell.svg(
                  height: 24,
                  width: 24,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(Insets.smallNormal),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Insets.small),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhanced(bool hasUpcomingEvent) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: 240,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 8),
            child: UpcomingEventEnhanced(
              title: 'Duminică seara la elsh',
              hour: '18:00',
              hasUpcomingEvent: hasUpcomingEvent,
            ),
          ),
        ),
        Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 16),
                child: GroupTile(
                  title: 'Group',
                    hasUpcomingEvent: hasUpcomingEvent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: 112,
              child: const Padding(
                padding: EdgeInsets.only(left: 8, right: 16),
                child: SavedSongsTile(
                  title: 'Duminică seara',
                  hour: '18:00',
                  location: 'Sala El-Shaddai',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
