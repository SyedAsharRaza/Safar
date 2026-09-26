class TrustedContact {
  const TrustedContact({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
    this.isPrimary = false,
  });

  final String id;
  final String name;
  final String relation;
  final String phone;
  final bool isPrimary;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters(2);
    return '${parts.first.characters(1)}${parts.last.characters(1)}';
  }

  /// Phone shown partially masked — the prototype never needs the full number.
  String get maskedPhone {
    if (phone.length < 5) return phone;
    return '${phone.substring(0, phone.length - 4)}••••';
  }

  TrustedContact copyWith({bool? isPrimary}) => TrustedContact(
        id: id,
        name: name,
        relation: relation,
        phone: phone,
        isPrimary: isPrimary ?? this.isPrimary,
      );
}

extension on String {
  String characters(int n) =>
      length <= n ? toUpperCase() : substring(0, n).toUpperCase();
}
