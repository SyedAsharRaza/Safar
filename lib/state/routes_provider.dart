import 'package:flutter/material.dart';

import '../data/services/route_planner.dart';
import '../models/route_option.dart';
import '../models/safety_report.dart';
import '../models/saved_place.dart';

enum PlanState { idle, planning, ready, empty, tooClose, error }

enum RouteSort {
  recommended('Recommended'),
  fastest('Fastest'),
  lowestCaution('Lowest reported caution'),
  shortest('Shortest distance');

  const RouteSort(this.label);
  final String label;
}

/// Holds the current trip and the planned route options.
class RoutesProvider extends ChangeNotifier {
  Place? _origin;
  Place? _destination;
  List<RouteOption> _options = [];
  RouteOption? _selected;
  PlanState _state = PlanState.idle;
  String? _error;
  RouteSort _sort = RouteSort.recommended;

  Place? get origin => _origin;
  Place? get destination => _destination;
  PlanState get state => _state;
  String? get error => _error;
  RouteSort get sort => _sort;
  RouteOption? get selected => _selected;

  bool get canPlan => _origin != null && _destination != null;

  List<RouteOption> get options {
    final list = [..._options];
    switch (_sort) {
      case RouteSort.recommended:
        list.sort((a, b) {
          if (a.isRecommended != b.isRecommended) {
            return a.isRecommended ? -1 : 1;
          }
          return a.routeScore.compareTo(b.routeScore);
        });
      case RouteSort.fastest:
        list.sort((a, b) => a.totalMinutes.compareTo(b.totalMinutes));
      case RouteSort.lowestCaution:
        list.sort((a, b) => a.routeScore.compareTo(b.routeScore));
      case RouteSort.shortest:
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return list;
  }

  RouteOption? get fastest => _options.isEmpty
      ? null
      : _options.reduce((a, b) => a.minutes <= b.minutes ? a : b);

  void setOrigin(Place? p) {
    _origin = p;
    notifyListeners();
  }

  void setDestination(Place? p) {
    _destination = p;
    notifyListeners();
  }

  void swap() {
    final o = _origin;
    _origin = _destination;
    _destination = o;
    notifyListeners();
  }

  void setSort(RouteSort s) {
    _sort = s;
    notifyListeners();
  }

  void select(RouteOption? r) {
    _selected = r;
    notifyListeners();
  }

  void reset() {
    _options = [];
    _selected = null;
    _state = PlanState.idle;
    _error = null;
    notifyListeners();
  }

  /// Plans routes for the current origin/destination against live reports.
  Future<void> plan({
    required List<SafetyReport> reports,
    bool simulateError = false,
  }) async {
    if (!canPlan) return;
    _state = PlanState.planning;
    _error = null;
    _options = [];
    _selected = null;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (simulateError) {
      _state = PlanState.error;
      _error = 'Route service did not respond. Check your connection and retry.';
      notifyListeners();
      return;
    }

    // Two places on the same junction are not a trip to compare.
    if (RoutePlanner.sharesNode(_origin!, _destination!)) {
      _state = PlanState.tooClose;
      notifyListeners();
      return;
    }

    final planned = RoutePlanner.plan(
      origin: _origin!,
      destination: _destination!,
      reports: reports,
    );

    _options = planned;
    _state = planned.isEmpty ? PlanState.empty : PlanState.ready;
    _selected = planned.isEmpty ? null : options.first;
    notifyListeners();
  }

  /// Re-scores the existing routes after a new report is published, so the
  /// route cards visibly update during the demo.
  void rescore(List<SafetyReport> reports) {
    if (_origin == null || _destination == null || _options.isEmpty) return;
    final selectedId = _selected?.id;
    final replanned = RoutePlanner.plan(
      origin: _origin!,
      destination: _destination!,
      reports: reports,
    );
    if (replanned.isEmpty) return;
    _options = replanned;
    _selected = replanned.where((r) => r.id == selectedId).firstOrNull ??
        options.first;
    notifyListeners();
  }
}
