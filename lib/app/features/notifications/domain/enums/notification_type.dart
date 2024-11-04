enum NotificationType {
  TEAM_INVITATION_REQUEST,
  TEAM_INVITATION_ACCEPTED,
  TEAM_INVITATION_DECLINED,
  EVENT_INVITATION_REQUEST,
  EVENT_INVITATION_ACCEPTED,
  EVENT_INVITATION_DECLINED,
  INVITATION,
  NEW_REHEARSAL,
}

extension NotificationTypeX on NotificationType {
  String get name {
    switch (this) {
      case NotificationType.TEAM_INVITATION_REQUEST:
        return 'TEAM_INVITATION_REQUEST';
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        return 'TEAM_INVITATION_ACCEPTED';
      case NotificationType.TEAM_INVITATION_DECLINED:
        return 'TEAM_INVITATION_DECLINED';
      case NotificationType.EVENT_INVITATION_REQUEST:
        return 'EVENT_INVITATION_REQUEST';
      case NotificationType.EVENT_INVITATION_ACCEPTED:
        return 'EVENT_INVITATION_ACCEPTED';
      case NotificationType.EVENT_INVITATION_DECLINED:
        return 'EVENT_INVITATION_DECLINED';
      case NotificationType.INVITATION:
        return 'INVITATION';
      case NotificationType.NEW_REHEARSAL:
        return 'NEW_REHEARSAL';
    }
  }

  String get title {
    switch (this) {
      case NotificationType.TEAM_INVITATION_REQUEST:
        return 'Join Team';
      case NotificationType.TEAM_INVITATION_ACCEPTED:
        return 'Team Invitation Accepted';
      case NotificationType.TEAM_INVITATION_DECLINED:
        return 'Team Invitation Declined';
      case NotificationType.EVENT_INVITATION_REQUEST:
        return 'Event Invitation';
      case NotificationType.EVENT_INVITATION_ACCEPTED:
        return 'Event Invitation Accepted';
      case NotificationType.EVENT_INVITATION_DECLINED:
        return 'Event Invitation Declined';
      case NotificationType.INVITATION:
        return 'Invitation';
      case NotificationType.NEW_REHEARSAL:
        return 'New Rehearsal';
    }
  }
}
