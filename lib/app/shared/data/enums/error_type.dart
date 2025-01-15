enum ErrorType {
  PERMISSION_DENIED,
  RESOURCE_NOT_FOUND,
  TEAM_MEMBER_ALREADY_EXISTS,
  DUPLICATE_POSITION_NAME,
  DUPLICATE_GROUP_NAME,
  InternalServerError,
}

extension ErrorTypeX on ErrorType {
  String get name {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'PERMISSION_DENIED';
      case ErrorType.RESOURCE_NOT_FOUND:
        return 'RESOURCE_NOT_FOUND';
      case ErrorType.TEAM_MEMBER_ALREADY_EXISTS:
        return 'TEAM_MEMBER_ALREADY_EXISTS';
      case ErrorType.DUPLICATE_POSITION_NAME:
        return 'DUPLICATE_POSITION_NAME';
      case ErrorType.DUPLICATE_GROUP_NAME:
        return 'DUPLICATE_GROUP_NAME';
      case ErrorType.InternalServerError:
        return 'InternalServerError';
    }
  }

  String getDescription(String resourceName) {
    switch (this) {
      case ErrorType.PERMISSION_DENIED:
        return 'Permission denied';
      case ErrorType.RESOURCE_NOT_FOUND:
        return '$resourceName not found';
      case ErrorType.TEAM_MEMBER_ALREADY_EXISTS:
        return 'Team member already exists';
      case ErrorType.DUPLICATE_POSITION_NAME:
        return 'Position with this name already exists';
      case ErrorType.DUPLICATE_GROUP_NAME:
        return 'Group with this name already exists';
      case ErrorType.InternalServerError:
        return 'Internal server error';
    }
  }
}
