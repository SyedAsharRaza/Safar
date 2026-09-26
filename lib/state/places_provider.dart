import 'package:flutter/material.dart';

import '../data/mock/mock_places.dart';
import '../models/saved_place.dart';

/// Saved places and recent searches.
class PlacesProvider extends ChangeNotifier {
  PlacesProvider();

  List<SavedPlace> _saved = [...MockPlaces.savedSeed];
  List<Place> _recent = [...MockPlaces.recentSeed];

  List<SavedPlace> get saved => List.unmodifiable(_saved);
  List<Place> get recent => List.unmodifiable(_recent);

  bool get hasSaved => _saved.isNotEmpty;

  bool isSaved(String placeId) => _saved.any((s) => s.place.id == placeId);

  SavedPlace? quickPick(String label) =>
      _saved.where((s) => s.label == label).firstOrNull;

  /// Returns true when the place was added, false when it was removed.
  bool toggleSaved(Place place, {String? label}) {
    if (isSaved(place.id)) {
      _saved = _saved.where((s) => s.place.id != place.id).toList();
      notifyListeners();
      return false;
    }
    _saved = [
      ..._saved,
      SavedPlace(place: place, savedAt: DateTime.now(), label: label),
    ];
    notifyListeners();
    return true;
  }

  void relabel(String placeId, String? label) {
    _saved = [
      for (final s in _saved)
        if (s.place.id == placeId)
          SavedPlace(place: s.place, savedAt: s.savedAt, label: label)
        else
          s,
    ];
    notifyListeners();
  }

  void recordSearch(Place place) {
    _recent = [place, ..._recent.where((p) => p.id != place.id)].take(8).toList();
    notifyListeners();
  }

  void clearRecent() {
    _recent = [];
    notifyListeners();
  }

  /// Demo switch for the first-time-user state.
  void clearAll() {
    _saved = [];
    _recent = [];
    notifyListeners();
  }

  void restoreSeed() {
    _saved = [...MockPlaces.savedSeed];
    _recent = [...MockPlaces.recentSeed];
    notifyListeners();
  }
}
