/// Contribution tiers. Recognition, not authority — a high tier never means a
/// report is verified.
enum ContributorTier {
  newcomer('New traveller', 0),
  regular('Regular reporter', 10),
  trusted('Trusted reporter', 40),
  guide('Community guide', 100);

  const ContributorTier(this.label, this.threshold);
  final String label;
  final int threshold;

  static ContributorTier forCount(int reports) {
    var tier = ContributorTier.newcomer;
    for (final t in values) {
      if (reports >= t.threshold) tier = t;
    }
    return tier;
  }

  ContributorTier? get next {
    final i = values.indexOf(this);
    return i < values.length - 1 ? values[i + 1] : null;
  }
}

class UserProfile {
  const UserProfile({
    required this.handle,
    required this.joinedAt,
    required this.reportsSubmitted,
    required this.confirmationsGiven,
    required this.reportsHelpful,
    required this.tripsCompared,
    this.isAnonymous = true,
    this.homeArea = '',
  });

  final String handle;
  final DateTime joinedAt;
  final int reportsSubmitted;
  final int confirmationsGiven;

  /// How many of the user's reports other travellers confirmed.
  final int reportsHelpful;
  final int tripsCompared;
  final bool isAnonymous;
  final String homeArea;

  ContributorTier get tier => ContributorTier.forCount(reportsSubmitted);

  double get progressToNext {
    final next = tier.next;
    if (next == null) return 1;
    final span = next.threshold - tier.threshold;
    if (span <= 0) return 1;
    return ((reportsSubmitted - tier.threshold) / span).clamp(0.0, 1.0);
  }

  int get reportsToNext {
    final next = tier.next;
    if (next == null) return 0;
    return (next.threshold - reportsSubmitted).clamp(0, 999);
  }

  UserProfile copyWith({
    int? reportsSubmitted,
    int? confirmationsGiven,
    int? tripsCompared,
  }) =>
      UserProfile(
        handle: handle,
        joinedAt: joinedAt,
        reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
        confirmationsGiven: confirmationsGiven ?? this.confirmationsGiven,
        reportsHelpful: reportsHelpful,
        tripsCompared: tripsCompared ?? this.tripsCompared,
        isAnonymous: isAnonymous,
        homeArea: homeArea,
      );
}
