import 'package:flutter/material.dart';
import 'package:on_stage_app/app/analytics/analytics_service.dart';
import 'package:on_stage_app/app/features/about/presentation/about_screen.dart';
import 'package:on_stage_app/app/features/about/presentation/privacy_policy_screen.dart';
import 'package:on_stage_app/app/features/about/presentation/terms_of_conditions_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/add_event_moments_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_details_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/event_settings_screen.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/groups/group_template/presentation/groups_screen.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/loading/presentation/loading_screen.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/login/presentation/login_screen.dart';
import 'package:on_stage_app/app/features/login/presentation/sign_up_screen.dart';
import 'package:on_stage_app/app/features/notifications/presentation/notification_page.dart';
import 'package:on_stage_app/app/features/plan/presentation/plans_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/add_song_first_step_details.dart';
import 'package:on_stage_app/app/features/song/presentation/add_new_song/add_song_second_step_content.dart';
import 'package:on_stage_app/app/features/song/presentation/saved_songs_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/song_detail_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/song_details_with_pages_screen.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/team/presentation/add_team_member_screen.dart';
import 'package:on_stage_app/app/features/team/presentation/team_details_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/change_password_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/edit_user_profile_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/user/presentation/user_profile_info_screen.dart';
import 'package:on_stage_app/app/main_screen.dart';
import 'package:on_stage_app/app/router/app_router.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router_notifier.g.dart';

@Riverpod(keepAlive: true)
class NavigationNotifier extends _$NavigationNotifier {
  @override
  GoRouter build() {
    return _createRouter();
  }

  GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _homeShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _songsShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _eventsShellKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> _profileShellKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

  GlobalKey<NavigatorState> get homeShellKey => _homeShellKey;

  GlobalKey<NavigatorState> get songsShellKey => _songsShellKey;

  GlobalKey<NavigatorState> get eventsShellKey => _eventsShellKey;

  GlobalKey<NavigatorState> get profileShellKey => _profileShellKey;

  void _resetNavigatorKeys() {
    _rootNavigatorKey = GlobalKey<NavigatorState>();
    _homeShellKey = GlobalKey<NavigatorState>();
    _songsShellKey = GlobalKey<NavigatorState>();
    _eventsShellKey = GlobalKey<NavigatorState>();
    _profileShellKey = GlobalKey<NavigatorState>();
  }

  void resetRouterAndState() {
    _resetNavigatorKeys();
    state = _createRouter();
  }

  GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/welcome',
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final loginState = ref.watch(loginNotifierProvider);
        final isLoggedIn = loginState.isLoggedIn;
        final isLoading = loginState.isLoading;

        final currentLocation = state.uri.toString();

        logger.i('Current location: $currentLocation');
        logger.i('Is logged in: $isLoggedIn');
        logger.i('Is loading: $isLoading');
        logger.i('current location : $currentLocation');

        if (isLoading) {
          logger.i('Redirecting to loading screen');
          return '/loading';
        }

        if (isLoggedIn) {
          logger.i('Redirecting to home screen');
          if (['/login', '/welcome', '/login/signUp']
              .contains(currentLocation)) {
            return '/home';
          }
          logger.i('Redirecting to home screen');
          return null;
        } else {
          logger.i('Redirecting to login screen');
          if (!['/login', '/loading', '/login/signUp']
              .contains(currentLocation)) {
            return '/login';
          }
        }

        logger.i('Redirecting to welcome screen');
        return null;
      },
      routes: _routes(),
      errorPageBuilder: _errorPageBuilder,
    );
  }

  List<RouteBase> _routes() => [
        StatefulShellRoute.indexedStack(
          pageBuilder: (context, state, navigationShell) {
            return NoTransitionPage(
              child: MainScreen(navigationShell: navigationShell),
            );
          },
          branches: [
            StatefulShellBranch(
              navigatorKey: _homeShellKey,
              routes: [
                GoRoute(
                  name: AppRoute.home.name,
                  path: '/home',
                  pageBuilder: (context, state) {
                    ref
                        .read(analyticsServiceProvider.notifier)
                        .logScreenView(AppRoute.home.name);
                    return const NoTransitionPage(child: HomeScreen());
                  },
                  routes: [
                    GoRoute(
                      name: AppRoute.notification.name,
                      path: 'notification',
                      builder: (context, state) {
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.notification.name);
                        return const NotificationPage();
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _songsShellKey,
              routes: [
                GoRoute(
                  name: AppRoute.songs.name,
                  path: '/songs',
                  builder: (context, state) {
                    return const SongsScreen();
                  },
                  routes: [
                    GoRoute(
                      name: AppRoute.song.name,
                      path: 'song',
                      builder: (context, state) {
                        final songId = state.uri.queryParameters['songId']!;
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView('${AppRoute.song.name}/$songId');
                        return SongDetailScreen(songId: songId);
                      },
                      routes: [
                        GoRoute(
                          name: AppRoute.editSongInfo.name,
                          path: 'editSongInfo',
                          builder: (context, state) {
                            final songId = state.uri.queryParameters['songId'];
                            ref
                                .read(analyticsServiceProvider.notifier)
                                .logScreenView(AppRoute.editSongInfo.name);
                            return AddSongFirstStepDetails(songId: songId);
                          },
                        ),
                        GoRoute(
                          name: AppRoute.editSongContent.name,
                          path: 'editSongContent',
                          builder: (context, state) {
                            ref
                                .read(analyticsServiceProvider.notifier)
                                .logScreenView(AppRoute.editSongContent.name);
                            return const AddSongSecondStepContent();
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      name: AppRoute.createSongInfo.name,
                      path: 'createSongInfo',
                      builder: (context, state) {
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.createSongInfo.name);
                        return const AddSongFirstStepDetails();
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _eventsShellKey,
              routes: [
                GoRoute(
                  name: AppRoute.events.name,
                  path: '/events',
                  builder: (context, state) {
                    return const EventsScreen();
                  },
                  routes: [
                    GoRoute(
                      name: AppRoute.addEvent.name,
                      path: 'addEvent',
                      builder: (context, state) {
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.addEvent.name);
                        return const AddEventDetailsScreen();
                      },
                    ),
                    GoRoute(
                      name: AppRoute.songDetailsWithPages.name,
                      path: 'songDetailsWithPages',
                      builder: (context, state) {
                        final eventId = state.uri.queryParameters['eventId']!;
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(
                              AppRoute.songDetailsWithPages.name,
                            );
                        return SongDetailsWithPagesScreen(
                          eventId: eventId,
                        );
                      },
                    ),
                    GoRoute(
                      name: AppRoute.addEventSongs.name,
                      path: 'addEventSongs',
                      builder: (context, state) {
                        final eventId = state.uri.queryParameters['eventId']!;
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(
                              '${AppRoute.addEventSongs.name}/$eventId',
                            );
                        return AddEventMomentsScreen(eventId: eventId);
                      },
                    ),
                    GoRoute(
                      name: AppRoute.eventDetails.name,
                      path: 'eventDetails',
                      builder: (context, state) {
                        final eventId = state.uri.queryParameters['eventId']!;
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(
                              '${AppRoute.eventDetails.name}/$eventId',
                            );
                        return EventDetailsScreen(eventId);
                      },
                      routes: [
                        GoRoute(
                          name: AppRoute.eventSettings.name,
                          path: 'eventSettings',
                          builder: (context, state) {
                            ref
                                .read(analyticsServiceProvider.notifier)
                                .logScreenView(AppRoute.eventSettings.name);
                            return const EventSettingsScreen();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _profileShellKey,
              routes: [
                GoRoute(
                  name: AppRoute.profile.name,
                  path: '/profile',
                  builder: (context, state) {
                    return const ProfileScreen();
                  },
                  routes: [
                    GoRoute(
                      name: AppRoute.about.name,
                      path: 'about',
                      builder: (context, state) {
                        return const AboutScreen();
                      },
                      routes: [
                        GoRoute(
                          name: AppRoute.privacyPolicy.name,
                          path: 'privacyPolicy',
                          builder: (context, state) {
                            return const PrivacyPolicyScreen();
                          },
                        ),
                        GoRoute(
                          name: AppRoute.termsOfUse.name,
                          path: 'termsOfUse',
                          builder: (context, state) {
                            return const TermsOfUseScreen();
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      name: AppRoute.plans.name,
                      path: 'plans',
                      builder: (context, state) {
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.plans.name);
                        return const PlansScreen();
                      },
                    ),
                    GoRoute(
                      name: AppRoute.editUserProfile.name,
                      path: 'editUserProfile',
                      builder: (context, state) {
                        return const EditUserProfile();
                      },
                    ),
                    GoRoute(
                      name: AppRoute.userProfileInfo.name,
                      path: 'userProfileInfo',
                      builder: (context, state) {
                        final userId =
                            state.uri.queryParameters['userId'] ?? '';
                        return UserProfileInfoScreen(userId: userId);
                      },
                    ),
                    GoRoute(
                      name: AppRoute.changePassword.name,
                      path: 'changePassword',
                      builder: (context, state) {
                        return const ChangePasswordScreen();
                      },
                    ),
                    GoRoute(
                      name: AppRoute.teamDetails.name,
                      path: 'teamDetails',
                      builder: (context, state) {
                        final isCreating = bool.tryParse(
                              state.uri.queryParameters['isCreating']
                                  .toString(),
                            ) ??
                            false;
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.teamDetails.name);
                        return TeamDetailsScreen(
                          isCreating: isCreating,
                        );
                      },
                      routes: [
                        GoRoute(
                          name: AppRoute.groups.name,
                          path: 'groups',
                          builder: (context, state) {
                            return const GroupsScreen();
                          },
                        ),
                        GoRoute(
                          name: AppRoute.addTeamMember.name,
                          path: 'addTeamMember',
                          builder: (context, state) {
                            ref
                                .read(analyticsServiceProvider.notifier)
                                .logScreenView(AppRoute.addTeamMember.name);
                            return const AddTeamMemberScreen();
                          },
                        ),
                      ],
                    ),
                    GoRoute(
                      name: AppRoute.favorites.name,
                      path: 'favorites',
                      builder: (context, state) {
                        ref
                            .read(analyticsServiceProvider.notifier)
                            .logScreenView(AppRoute.favorites.name);
                        return const SavedSongsScreen();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRoute.loading.name,
          path: '/loading',
          pageBuilder: (context, state) {
            ref
                .read(analyticsServiceProvider.notifier)
                .logScreenView(AppRoute.loading.name);
            return const NoTransitionPage(
              child: LoadingScreen(),
            );
          },
        ),
        GoRoute(
          name: AppRoute.login.name,
          path: '/login',
          pageBuilder: (context, state) {
            ref
                .read(analyticsServiceProvider.notifier)
                .logScreenView(AppRoute.login.name);
            return const NoTransitionPage(child: LoginScreen());
          },
          routes: [
            GoRoute(
              name: AppRoute.signUp.name,
              path: 'signUp',
              builder: (context, state) {
                ref
                    .read(analyticsServiceProvider.notifier)
                    .logScreenView(AppRoute.signUp.name);
                return const SignUpScreen();
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoute.welcome.name,
          path: '/welcome',
          pageBuilder: (context, state) {
            ref
                .read(analyticsServiceProvider.notifier)
                .logScreenView(AppRoute.welcome.name);
            return const NoTransitionPage(
              child: HomeScreen(),
            );
          },
          redirect: (context, state) {
            return '/home';
          },
        ),
      ];

  Page<void> _errorPageBuilder(BuildContext context, GoRouterState state) {
    return MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text(
            state.error?.toString() ?? 'error message',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
