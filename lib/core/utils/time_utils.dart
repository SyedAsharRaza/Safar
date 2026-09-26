/// Relative-time and duration formatting. Written locally so the prototype does
/// not pull in `intl` for four helpers.
abstract final class TimeUtils {
  /// "12 min ago", "2 h ago", "Yesterday", "3 days ago".
  static String relative(DateTime when, {DateTime? from}) {
    final now = from ?? DateTime.now();
    final d = now.difference(when);
    if (d.isNegative) return 'Just now';
    if (d.inSeconds < 45) return 'Just now';
    if (d.inMinutes < 60) return '${d.inMinutes} min ago';
    if (d.inHours < 24) {
      final h = d.inHours;
      return '$h ${h == 1 ? 'hour' : 'hours'} ago';
    }
    if (d.inDays == 1) return 'Yesterday';
    if (d.inDays < 7) return '${d.inDays} days ago';
    if (d.inDays < 30) {
      final w = (d.inDays / 7).floor();
      return '$w ${w == 1 ? 'week' : 'weeks'} ago';
    }
    final m = (d.inDays / 30).floor();
    return '$m ${m == 1 ? 'month' : 'months'} ago';
  }

  /// Compact form for dense chips: "12m", "3h", "5d".
  static String compact(DateTime when, {DateTime? from}) {
    final d = (from ?? DateTime.now()).difference(when);
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    if (d.inDays < 30) return '${d.inDays}d';
    return '${(d.inDays / 30).floor()}mo';
  }

  /// "expires in 4 h", or "expired" when already past.
  static String untilExpiry(DateTime? expiresAt, {DateTime? from}) {
    if (expiresAt == null) return 'No expiry set';
    final now = from ?? DateTime.now();
    if (now.isAfter(expiresAt)) return 'Expired';
    final d = expiresAt.difference(now);
    if (d.inMinutes < 60) return 'Expires in ${d.inMinutes} min';
    if (d.inHours < 24) {
      final h = d.inHours;
      return 'Expires in $h ${h == 1 ? 'hour' : 'hours'}';
    }
    final days = d.inDays;
    return 'Expires in $days ${days == 1 ? 'day' : 'days'}';
  }

  /// mm:ss for the check-in countdown.
  static String clock(Duration d) {
    final total = d.inSeconds.clamp(0, 359999);
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    final s = total % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
  }

  /// "31 min" / "1 h 12 min" for route durations.
  static String minutes(num m) {
    final total = m.round();
    if (total < 60) return '$total min';
    final h = total ~/ 60;
    final rem = total % 60;
    return rem == 0 ? '$h h' : '$h h $rem min';
  }

  static String distance(double km) =>
      km < 1 ? '${(km * 1000).round()} m' : '${km.toStringAsFixed(1)} km';

  /// "9:15 PM"
  static String timeOfDay(DateTime t) {
    final h24 = t.hour;
    final h = h24 % 12 == 0 ? 12 : h24 % 12;
    final suffix = h24 < 12 ? 'AM' : 'PM';
    return '$h:${t.minute.toString().padLeft(2, '0')} $suffix';
  }

  static String dayMonth(DateTime t) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${t.day} ${months[t.month - 1]}';
  }

  /// Greeting that leans into the product's evening-travel moment.
  static String greeting({DateTime? at}) {
    final h = (at ?? DateTime.now()).hour;
    if (h < 5) return 'Travelling late';
    if (h < 12) return 'Good morning';
    if (h < 16) return 'Good afternoon';
    if (h < 19) return 'Good evening';
    return 'Travelling tonight';
  }

  static bool isAfterDark({DateTime? at}) {
    final h = (at ?? DateTime.now()).hour;
    return h >= 19 || h < 6;
  }
}
