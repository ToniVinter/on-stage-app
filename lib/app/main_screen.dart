import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:on_stage_app/app/database/app_database.dart';
import 'package:on_stage_app/app/device/application/device_service.dart';
import 'package:on_stage_app/app/features/event/presentation/events_screen.dart';
import 'package:on_stage_app/app/features/firebase/application/firebase_notifier.dart';
import 'package:on_stage_app/app/features/home/presentation/home_screen.dart';
import 'package:on_stage_app/app/features/login/application/login_notifier.dart';
import 'package:on_stage_app/app/features/notifications/application/notification_notifier.dart';
import 'package:on_stage_app/app/features/permission/application/network_permission_notifier.dart';
import 'package:on_stage_app/app/features/plan/application/plan_service.dart';
import 'package:on_stage_app/app/features/song/presentation/songs_screen.dart';
import 'package:on_stage_app/app/features/subscription/presentation/paywall_modal.dart';
import 'package:on_stage_app/app/features/subscription/subscription_notifier.dart';
import 'package:on_stage_app/app/features/team/application/team_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/current_team_member/current_team_member_notifier.dart';
import 'package:on_stage_app/app/features/team_member/application/team_members_notifier.dart';
import 'package:on_stage_app/app/features/user/application/user_notifier.dart';
import 'package:on_stage_app/app/features/user/domain/enums/permission_type.dart';
import 'package:on_stage_app/app/features/user/presentation/profile_screen.dart';
import 'package:on_stage_app/app/features/user_settings/application/user_settings_notifier.dart';
import 'package:on_stage_app/app/shared/adaptive_event_pop_dialog.dart';
import 'package:on_stage_app/app/shared/custom_side_navigation.dart';
import 'package:on_stage_app/app/socket_io_service/socket_io_service.dart';
import 'package:on_stage_app/app/utils/build_context_extensions.dart';
import 'package:on_stage_app/logger.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<Widget> screens = [
    const HomeScreen(),
    const SongsScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  bool _isNavigationExpanded = false;

  Future<void> _onChangedScreen(int index) async {
    final currentPath =
        widget.navigationShell.shellRouteContext.routerState.fullPath;
    final isAddEventScreen = currentPath == '/events/addEvent';
    final isNavigatingToEvents = index == 2;

    if (isAddEventScreen && isNavigatingToEvents) {
      if (!mounted) return;

      final shouldPop = await AdaptiveEventPopDialog.show(context: context);
      if (!(shouldPop ?? false) || !mounted) return;
    }

    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initProviders();
    });
    super.initState();
  }

  Future<void> _initProviders() async {
    logger.i('Init providers');
    await ref.read(databaseProvider).initDatabase();
    ref.read(socketIoServiceProvider.notifier);
    ref.read(firebaseNotifierProvider.notifier);

    await Future.wait([
      ref.read(deviceServiceProvider).verifyDeviceId(),
      ref
          .read(teamMembersNotifierProvider.notifier)
          .fetchAndSaveTeamMemberPhotos(),
      ref.read(userNotifierProvider.notifier).init(),
      ref.read(teamNotifierProvider.notifier).getCurrentTeam(),
      ref.read(currentTeamMemberNotifierProvider.notifier).initializeState(),
      ref.read(userSettingsNotifierProvider.notifier).init(),
      ref.read(subscriptionNotifierProvider.notifier).init(),
      ref
          .read(planServiceProvider.notifier)
          .fetchAndSavePlans(forceRefresh: true),
    ]).then((_) {
      ref.read(notificationNotifierProvider.notifier).getNotifications();

      logger.i('All providers initialized');
    }).catchError((error, s) {
      logger.e('Error during provider initialization: $error $s');
    });
  }

  bool _shouldHideBottomNav(String location) {
    return [
      '/events/songDetailsWithPages',
      '/events/addEvent',
    ].any((route) => location.startsWith(route));
  }

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    _listenForPermissionDeniedAndShowPaywall();
    final horizontalPadding = context.screenSize.width > 1200 ? 132.0 : 23.0;
    return Scaffold(
      backgroundColor: context.isLargeScreen && !context.isDarkMode
          ? context.colorScheme.onSurfaceVariant
          : context.colorScheme.surface,
      bottomNavigationBar:
          _shouldHideBottomNav(currentLocation) || context.isLargeScreen
              ? null
              : BottomNavigationBar(
                  currentIndex: widget.navigationShell.currentIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: context.colorScheme.surface,
                  selectedLabelStyle: context.textTheme.bodyMedium,
                  unselectedLabelStyle: context.textTheme.bodyMedium,
                  selectedItemColor: context.colorScheme.onSurface,
                  unselectedItemColor: context.colorScheme.outline,
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                  elevation: 1,
                  onTap: _onChangedScreen,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Badge(
                        isLabelVisible: ref
                            .watch(notificationNotifierProvider)
                            .hasNewNotifications,
                        backgroundColor: Colors.red,
                        child: SvgPicture.asset(
                          'assets/icons/nav_home_icon.svg',
                          height: 21,
                          colorFilter: ColorFilter.mode(
                            context.colorScheme.onSurface,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      icon: Badge(
                        isLabelVisible: ref
                            .watch(notificationNotifierProvider)
                            .hasNewNotifications,
                        backgroundColor: Colors.red,
                        child: SvgPicture.asset(
                          'assets/icons/nav_home_icon.svg',
                          height: 21,
                          colorFilter: ColorFilter.mode(
                            context.colorScheme.outline,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      label: 'Home',
                      backgroundColor: Colors.white,
                    ),
                    BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset(
                        'assets/icons/nav_list_music_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/nav_list_music_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.outline,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Songs',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset(
                        'assets/icons/nav_calendar_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/nav_calendar_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.outline,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Events',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: SvgPicture.asset(
                        'assets/icons/nav_profile_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      icon: SvgPicture.asset(
                        'assets/icons/nav_profile_icon.svg',
                        height: 21,
                        colorFilter: ColorFilter.mode(
                          context.colorScheme.outline,
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
      body: context.isLargeScreen
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavigationRail(context),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 32, bottom: 32, right: 23),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: context.colorScheme.surfaceContainerHigh,
                      ),
                      child: widget.navigationShell,
                    ),
                  ),
                ),
              ],
            )
          : widget.navigationShell,
    );
  }

  Widget _buildNavigationRail(BuildContext context) {
    return CustomSideNavigation(
      selectedIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: _onChangedScreen,
      isExpanded: _isNavigationExpanded,
      items: _navigationItems,
      onExpandToggle: () {
        setState(() {
          _isNavigationExpanded = !_isNavigationExpanded;
        });
      },
      onSignOut: () {
        ref.read(loginNotifierProvider.notifier).signOut();
      },
    );
  }

  void _listenForPermissionDeniedAndShowPaywall() {
    ref.listen<PermissionType?>(
      networkPermissionProvider,
      (previous, permissionType) {
        if (permissionType != null) {
          PaywallModal.show(
            context: context,
            permissionType: permissionType,
          );

          ref.read(networkPermissionProvider.notifier).clearPermission();
        }
      },
    );
  }
}

final List<NavigationItem> _navigationItems = [
  NavigationItem(
    label: 'Home',
    iconPath: 'assets/icons/nav_home_icon.svg',
  ),
  NavigationItem(
    label: 'Songs',
    iconPath: 'assets/icons/nav_list_music_icon.svg',
  ),
  NavigationItem(
    label: 'Events',
    iconPath: 'assets/icons/nav_calendar_icon.svg',
  ),
  NavigationItem(
    label: 'Profile',
    iconPath: 'assets/icons/nav_profile_icon.svg',
  ),
];

class NavigationItem {
  NavigationItem({
    required this.label,
    required this.iconPath,
  });

  final String label;
  final String iconPath;
}
