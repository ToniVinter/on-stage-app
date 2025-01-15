import 'package:on_stage_app/app/utils/environment_manager.dart';

class API {
  // static const String devDomain = 'dev.on-stage.app';
  // static const String socketDevDomain = 'dev.on-stage.app';
  //
  // static const String prodDomain = 'on-stage.app/api';
  // static const String socketProdDomain = 'on-stage.app';
  //
  // // static const String domain = '0e2f-79-119-41-169.ngrok-free.app';
  // static const String baseUrl = 'https://$prodDomain/';
  // static const String socketUrl = 'wss://$socketProdDomain/';
  //
  // // static const String baseUrl = 'http://fb72-86-127-188-157.ngrok-free.app/';

  static const String devDomain = 'dev.on-stage.app';
  static const String socketDevDomain = 'dev.on-stage.app';

  static const String prodDomain = 'on-stage.app/api';
  static const String socketProdDomain = 'on-stage.app';

  static String get baseUrl =>
      EnvironmentManager.currentEnvironment == AppEnvironment.development
          ? 'https://$devDomain/'
          : 'https://$prodDomain/';

  static String get socketUrl =>
      EnvironmentManager.currentEnvironment == AppEnvironment.development
          ? 'wss://$socketDevDomain/'
          : 'wss://$socketProdDomain/';

  static Future<Map<String, String>> getHeaders() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    return headers;
  }

  //Events
  static const String eventsByFilter = 'events?{startDate}&{endDate}&{search}';
  static const String eventById = 'events/{id}';
  static const String duplicateEvent = 'events/duplicate/{id}';
  static const String events = 'events';
  static const String rehearsals = 'rehearsals';
  static const String rehearsalById = 'rehearsals/{id}';
  static const String eventItems = 'event-items';
  static const String leadVocalsByEventItemId = 'event-items/{id}/lead-vocals';
  static const String leadVocalsByEventItemIdAndStagerId =
      'event-items/{id}/lead-vocals/{stagerId}';
  static const String upcomingEvent = 'events/upcoming';

  static const String stagers = 'stagers';

  static const String stagersById = 'stagers/{id}';
  static const String editStagerById = 'stagers/{id}';
  static const String stagerByEventAndTeamMember =
      'stagers/getByEventAndTeamMember';

  static const String artists = 'artists';

  static const String reminders = 'reminders';

  //Songs
  static const String getSongs = 'songs';
  static const String getSongsWithPagination = 'songs/paginated';
  static const String getSongsCount = 'songs/count';
  static const String addSong = 'songs';
  static const String updateSongById = 'songs/{id}';
  static const String getSongsById = 'songs/{id}';
  static const String savedSongs = 'songs/favorites';
  static const String savedSongsWithUserId = 'songs/favorites/{songId}';

  static const String verifyToken = 'verifyToken';
  static const String login = 'auth/login';
  static const String refreshToken = 'auth/refresh-token';
  static const String logout = 'auth/logout';

  static const String users = 'users';
  static const String currentUser = 'users/current';
  static const String user = 'users/{id}';
  static const String userProfileInfo = 'users/{id}/profile-info';
  static const String userPhoto = 'users/photo/currentUser';
  static const String checkPermission = 'users/check-permission';

  static const String photoByUserId = 'users/photo/{userId}';
  static const String photo = 'users/photo';

  static const String teams = 'teams';
  static const String teamById = 'teams/{id}';
  static const String currentTeam = 'teams/current';
  static const String setCurrentTeam = 'users/team/{teamId}';

  static const String teamMembers = 'team-members';
  static const String teamMembersById = 'team-members/{id}';
  static const String currentTeamMember = 'team-members/current';
  static const String uninvitedTeamMembers = 'team-members/uninvited';
  static const String addTeamMember = 'team-members/invite';
  static const String teamMemberPhotos = 'team-members/photos';

  static const String userSettings = 'user-settings';

  static const String notifications = 'notifications';
  static const String notificationsMarkAsViewed = 'notifications/viewed';
  static const String notificationById = 'notifications/{id}';

  //song-config
  static const String songConfigBySongId = 'song-config/{songId}';
  static const String songConfig = 'song-config';

  //ws
  static const String wsTopicMessage = '/user';
  static const String wsNotifications = 'notifications';

  //subscriptions
  static const String intentSecret = 'stripe/setupIntent';
  static const String currentSubscription = 'subscriptions/current';

  //devices
  static const String devices = 'devices';
  static const String deviceById = 'devices/{id}';
  static const String deviceLogin = 'devices/login';

  static const String plans = 'plans';

  //positions
  static const String groupsTemplate = 'groups/template';
  static const String groupTemplate = 'groups/{id}/template';
  static const String getGroupsForEvent = 'groups/events/{id}';
  static const String createGroup = 'groups';
  static const String updateGroup = 'groups/{id}';
  static const String deleteGroup = 'groups/{id}';

  static const String groupsForEvent = 'groups/events/{eventId}';
  static const String groupEventById = 'groups/{groupId}/events/{eventId}';

  static const String getPositions = 'positions/groups/{id}';
  static const String createPositon = 'positions';
  static const String updatePosition = 'positions/{id}';
  static const String deletePosition = 'positions/{id}';

  static const String getAllPositionsWithStagers = 'positions/stagers';
}
