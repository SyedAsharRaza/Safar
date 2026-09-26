import 'package:flutter/material.dart';

import 'geo.dart';

enum PlaceKind {
  home('Home'),
  work('Work / study'),
  landmark('Landmark'),
  market('Market'),
  hospital('Hospital'),
  campus('Campus'),
  transport('Transport'),
  neighbourhood('Neighbourhood'),
  park('Park');

  const PlaceKind(this.label);
  final String label;

  IconData get icon => switch (this) {
        PlaceKind.home => Icons.home_outlined,
        PlaceKind.work => Icons.work_outline,
        PlaceKind.landmark => Icons.account_balance_outlined,
        PlaceKind.market => Icons.storefront_outlined,
        PlaceKind.hospital => Icons.local_hospital_outlined,
        PlaceKind.campus => Icons.school_outlined,
        PlaceKind.transport => Icons.directions_bus_outlined,
        PlaceKind.neighbourhood => Icons.location_city_outlined,
        PlaceKind.park => Icons.park_outlined,
      };
}

class Place {
  const Place({
    required this.id,
    required this.name,
    required this.area,
    required this.kind,
    required this.location,
    this.subtitle = '',
  });

  final String id;
  final String name;
  final String area;
  final PlaceKind kind;
  final GeoPoint location;
  final String subtitle;

  String get displaySubtitle => subtitle.isNotEmpty ? subtitle : area;

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return name.toLowerCase().contains(q) ||
        area.toLowerCase().contains(q) ||
        kind.label.toLowerCase().contains(q) ||
        subtitle.toLowerCase().contains(q);
  }
}

/// A place the user pinned, with an optional custom label.
class SavedPlace {
  const SavedPlace({
    required this.place,
    required this.savedAt,
    this.label,
  });

  final Place place;
  final DateTime savedAt;
  final String? label;

  String get title => label ?? place.name;
}
