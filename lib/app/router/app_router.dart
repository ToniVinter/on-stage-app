import 'package:go_router/go_router.dart';

export 'package:go_router/go_router.dart';

enum AppRoute {
  login,
  welcome,
  home,
  songs,
  events,
  addEvent,
  eventDetails,
  profile,
  song,
  notification,
  favorites,
  vocalModal,
  addEventSongs,
  eventSettings,
  editUserProfile,
  teamDetails,
  changePassword,
  addTeamMember,
  onboarding,
  loading,
  signUp,
  eventItemsWithPages,
  createSongInfo,
  addStructureForSong,
  plans,
  about,
  privacyPolicy,
  termsOfUse,
  userProfileInfo,
  editSongInfo,
  editSongContent,
  groups,
  momentDetails,
}

extension GoRouterExtension on GoRouter {
  String nameLocation(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
  }) {
    final location = namedLocation(
      name,
      pathParameters: params,
      queryParameters: queryParams,
    );
    return location.replaceAll('?', '');
  }
}

extension GoRouterStateExtension on GoRouterState {
  String nameLocation(
    String name, {
    Map<String, String> params = const <String, String>{},
    Map<String, String> queryParams = const <String, String>{},
  }) {
    final location = namedLocation(
      name,
      pathParameters: params,
      queryParameters: queryParams,
    );
    return location.replaceAll('?', '');
  }
}
