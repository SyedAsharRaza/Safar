import '../../models/saved_place.dart';
import 'bahawalpur_geo.dart';

/// Searchable destinations in the demo area. Real Bahawalpur landmarks so the
/// prototype reads as a local product rather than filler.
abstract final class MockPlaces {
  static const List<Place> all = [
    Place(
      id: 'pl_fawara',
      name: 'Fawara Chowk',
      area: 'Inner city',
      kind: PlaceKind.landmark,
      location: BwpGeo.fawaraChowk,
      subtitle: 'Central junction, Circular Road',
    ),
    Place(
      id: 'pl_farid_gate',
      name: 'Farid Gate',
      area: 'Inner city',
      kind: PlaceKind.landmark,
      location: BwpGeo.faridGate,
      subtitle: 'Old city gate, near Shahi Bazaar',
    ),
    Place(
      id: 'pl_noor_mahal',
      name: 'Noor Mahal',
      area: 'Noor Mahal Road',
      kind: PlaceKind.landmark,
      location: BwpGeo.noorMahal,
      subtitle: 'Palace and gardens',
    ),
    Place(
      id: 'pl_darbar_mahal',
      name: 'Darbar Mahal',
      area: 'Cantonment side',
      kind: PlaceKind.landmark,
      location: BwpGeo.darbarMahal,
      subtitle: 'Heritage palace',
    ),
    Place(
      id: 'pl_iub',
      name: 'Islamia University (Baghdad-ul-Jadeed)',
      area: 'University corridor',
      kind: PlaceKind.campus,
      location: BwpGeo.iubBaghdad,
      subtitle: 'Main campus, Baghdad-ul-Jadeed Road',
    ),
    Place(
      id: 'pl_bvh',
      name: 'Bahawal Victoria Hospital',
      area: 'Hospital Road',
      kind: PlaceKind.hospital,
      location: BwpGeo.bvhGate,
      subtitle: 'BVH main gate',
    ),
    Place(
      id: 'pl_qamc',
      name: 'Quaid-e-Azam Medical College',
      area: 'Hospital Road',
      kind: PlaceKind.campus,
      location: BwpGeo.qamcGate,
      subtitle: 'QAMC, next to BVH',
    ),
    Place(
      id: 'pl_railway',
      name: 'Bahawalpur Railway Station',
      area: 'Station area',
      kind: PlaceKind.transport,
      location: BwpGeo.railwayStation,
      subtitle: 'Railway Road',
    ),
    Place(
      id: 'pl_dring',
      name: 'Dring Stadium',
      area: 'Stadium Road',
      kind: PlaceKind.park,
      location: BwpGeo.dringStadium,
      subtitle: 'Cricket stadium',
    ),
    Place(
      id: 'pl_sherbagh',
      name: 'Sherbagh (Bahawalpur Zoo)',
      area: 'Inner city',
      kind: PlaceKind.park,
      location: BwpGeo.sherbagh,
      subtitle: 'Zoo and public garden',
    ),
    Place(
      id: 'pl_model_town_a',
      name: 'Model Town A',
      area: 'Model Town',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.modelTownA,
      subtitle: 'Residential blocks',
    ),
    Place(
      id: 'pl_model_town_c',
      name: 'Model Town C',
      area: 'Model Town',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.modelTownC,
      subtitle: 'Residential blocks',
    ),
    Place(
      id: 'pl_satellite',
      name: 'Satellite Town',
      area: 'Satellite Town',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.satelliteTown,
      subtitle: 'Market and housing',
    ),
    Place(
      id: 'pl_abbasia',
      name: 'Abbasia Town',
      area: 'Multan Road',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.abbasiaTown,
      subtitle: 'Off Multan Road',
    ),
    Place(
      id: 'pl_trust_colony',
      name: 'Trust Colony',
      area: 'Trust Colony',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.trustColony,
      subtitle: 'Residential lanes',
    ),
    Place(
      id: 'pl_cantt',
      name: 'Bahawalpur Cantt',
      area: 'Cantonment',
      kind: PlaceKind.neighbourhood,
      location: BwpGeo.canttGate,
      subtitle: 'Cantt Road',
    ),
    Place(
      id: 'pl_shahi_bazaar',
      name: 'Shahi Bazaar',
      area: 'Inner city',
      kind: PlaceKind.market,
      location: BwpGeo.shahiBazaar,
      subtitle: 'Cloth and general market',
    ),
    Place(
      id: 'pl_machhli_bazaar',
      name: 'Machhli Bazaar',
      area: 'Inner city',
      kind: PlaceKind.market,
      location: BwpGeo.machhliBazaar,
      subtitle: 'Narrow market lanes',
    ),
    Place(
      id: 'pl_ghalla_mandi',
      name: 'Ghalla Mandi',
      area: 'Ghalla Mandi',
      kind: PlaceKind.market,
      location: BwpGeo.ghallaMandi,
      subtitle: 'Grain market',
    ),
    Place(
      id: 'pl_airport',
      name: 'Bahawalpur Airport',
      area: 'Airport Road',
      kind: PlaceKind.transport,
      location: BwpGeo.airportRoad,
      subtitle: 'Domestic terminal',
    ),
    Place(
      id: 'pl_one_unit',
      name: 'One Unit Chowk',
      area: 'Circular Road',
      kind: PlaceKind.landmark,
      location: BwpGeo.oneUnitChowk,
      subtitle: 'Junction toward Model Town',
    ),
    Place(
      id: 'pl_bypass',
      name: 'Bahawalpur Bypass',
      area: 'City edge',
      kind: PlaceKind.landmark,
      location: BwpGeo.bypassNorth,
      subtitle: 'Northern bypass',
    ),
  ];

  static Place byId(String id) =>
      all.firstWhere((p) => p.id == id, orElse: () => all.first);

  /// Pre-pinned places for the returning-user demo state.
  static final List<SavedPlace> savedSeed = [
    SavedPlace(
      place: byId('pl_model_town_a'),
      savedAt: DateTime.now().subtract(const Duration(days: 34)),
      label: 'Home',
    ),
    SavedPlace(
      place: byId('pl_iub'),
      savedAt: DateTime.now().subtract(const Duration(days: 30)),
      label: 'University',
    ),
    SavedPlace(
      place: byId('pl_shahi_bazaar'),
      savedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  /// Recent searches for the returning-user demo state.
  static final List<Place> recentSeed = [
    byId('pl_iub'),
    byId('pl_railway'),
    byId('pl_bvh'),
    byId('pl_noor_mahal'),
  ];

  static List<Place> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    final results = all.where((p) => p.matches(q)).toList();
    // Prefix matches on the name float to the top.
    results.sort((a, b) {
      final aStarts = a.name.toLowerCase().startsWith(q) ? 0 : 1;
      final bStarts = b.name.toLowerCase().startsWith(q) ? 0 : 1;
      if (aStarts != bStarts) return aStarts - bStarts;
      return a.name.compareTo(b.name);
    });
    return results;
  }
}
