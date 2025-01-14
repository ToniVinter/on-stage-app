import 'package:intl/intl.dart';

class TimeUtils {
  DateTime getEndOfTheWeekDateTime() {
    final now = DateTime.now().subtract(Duration(hours: DateTime.now().hour));
    const lastDayOfWeek = DateTime.sunday;
    final remainingDays = lastDayOfWeek - now.weekday;
    final endOfTheWeek = DateTime.now().add(Duration(days: remainingDays));
    return endOfTheWeek;
  }

  DateTime getNowDateTime() {
    return DateTime.now().subtract(Duration(hours: DateTime.now().hour));
  }

  DateTime getYesterdayDateTime() {
    return DateTime.now().subtract(const Duration(days: 1));
  }

  DateTime getStartOfTheNextWeekDateTime() {
    final endOfTheWeek = getEndOfTheWeekDateTime();
    final startOfTheNextWeek = endOfTheWeek.add(const Duration(days: 1));
    return startOfTheNextWeek;
  }

  String formatDateTime(DateTime? datetime) {
    return datetime != null ? DateFormat('EEEE, dd MMMM').format(datetime) : '';
  }

  String formatOnlyDate(DateTime? dateTime) {
    try {
      return dateTime != null ? DateFormat('d MMM.').format(dateTime) : '';
    } catch (e) {
      return 'Invalid date';
    }
  }

  String formatOnlyTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('HH:mm').format(dateTime) : '';
  }

  DateTime? parseDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return null;
    }
  }

  DateTime approximateToNearestInterval(DateTime dateTime, int minuteInterval) {
    final minute = dateTime.minute;
    final remainder = minute % minuteInterval;
    final adjustment = remainder < (minuteInterval / 2)
        ? -remainder
        : (minuteInterval - remainder);

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      minute + adjustment,
    );
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '0:00';

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}min';
    }

    if (minutes == 0) {
      return '${hours}h';
    }

    return '${hours}h ${minutes}min';
  }
}
