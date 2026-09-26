import '../../models/geo.dart';
import '../../models/road_segment.dart';
import '../../models/route_option.dart';
import '../../models/safety_report.dart';
import '../../models/saved_place.dart';
import '../../models/taxonomy.dart';
import '../mock/bahawalpur_geo.dart';
import 'awareness_engine.dart';

/// Builds the three route options by running shortest-path searches over the
/// seeded road network with three different cost functions.
///
/// This is deliberately deterministic Dart, not an API call and not AI: given
/// the same reports it always produces the same routes, which is what makes the
/// route explanations trustworthy.
abstract final class RoutePlanner {
  /// Nodes are quantised segment endpoints, so segments that meet at a
  /// junction share a graph node.
  static String _nodeKey(GeoPoint p) =>
      '${(p.lat * 10000).round()}_${(p.lng * 10000).round()}';

  /// Graph and node table are built together, on first use. They were
  /// previously two separate lazy fields, which let a caller read the node
  /// table before the graph initializer had populated it.
  static _Network? _network;

  static _Network get _net => _network ??= _buildNetwork();

  static _Network _buildNetwork() {
    final edges = <String, List<_Edge>>{};
    final points = <String, GeoPoint>{};
    for (final seg in BwpGeo.segments) {
      if (seg.path.length < 2) continue;
      final a = seg.path.first;
      final b = seg.path.last;
      final ka = _nodeKey(a);
      final kb = _nodeKey(b);
      points[ka] = a;
      points[kb] = b;
      // Roads are two-way in this prototype.
      (edges[ka] ??= []).add(_Edge(seg, kb));
      (edges[kb] ??= []).add(_Edge(seg, ka));
    }
    return _Network(edges: edges, points: points);
  }

  static String _nearestNode(GeoPoint target) {
    final points = _net.points;
    var best = points.keys.first;
    var bestD = double.infinity;
    for (final entry in points.entries) {
      final d = entry.value.distanceKmTo(target);
      if (d < bestD) {
        bestD = d;
        best = entry.key;
      }
    }
    return best;
  }

  /// True when two places resolve to the same point on the road network, i.e.
  /// they are close enough that comparing routes is meaningless.
  static bool sharesNode(Place a, Place b) =>
      _nearestNode(a.location) == _nearestNode(b.location);

  /// Plans up to three meaningfully different routes between two places.
  ///
  /// Returns fewer than three when the network genuinely offers no distinct
  /// alternative — the UI has a state for that rather than inventing options.
  static List<RouteOption> plan({
    required Place origin,
    required Place destination,
    required List<SafetyReport> reports,
    DateTime? now,
  }) {
    final at = now ?? DateTime.now();
    final start = _nearestNode(origin.location);
    final goal = _nearestNode(destination.location);
    if (start == goal) return const [];

    final awarenessBySegment = <String, SegmentAwareness>{
      for (final s in BwpGeo.segments)
        s.id: AwarenessEngine.scoreSegment(s, reports, now: at),
    };

    double cost(RoadSegment seg, _Objective obj, Set<String> penalised) {
      final a = awarenessBySegment[seg.id]!;
      final minutes = seg.baseMinutes + a.extraMinutes;
      // Nudge later searches away from segments already used, so the three
      // options are visibly different where the network allows it.
      final variety = penalised.contains(seg.id) ? minutes * 0.55 : 0.0;
      return switch (obj) {
        _Objective.fastest =>
          minutes + variety + (a.hasHardBlock ? 25 : 0),
        _Objective.betterLit => minutes +
            variety +
            a.lightingScore * 26 * seg.lengthKm +
            (1 - seg.activityScore) * 7 * seg.lengthKm +
            (a.hasHardBlock ? 60 : 0),
        _Objective.fewerHazards => minutes +
            variety +
            a.score * 34 * seg.lengthKm +
            (a.hasHardBlock ? 140 : 0),
      };
    }

    final plans = <_Objective, List<RoadSegment>>{};
    final used = <String>{};

    for (final obj in _Objective.values) {
      final path = _dijkstra(
        start,
        goal,
        (seg) => cost(seg, obj, obj == _Objective.fastest ? const {} : used),
      );
      if (path.isEmpty) continue;
      plans[obj] = path;
      if (obj == _Objective.fastest) used.addAll(path.map((s) => s.id));
    }

    if (plans.isEmpty) return const [];

    // Drop duplicates: two objectives agreeing means there is only one
    // sensible route, which is honest information for the traveller.
    final seen = <String>{};
    final options = <RouteOption>[];
    for (final entry in plans.entries) {
      final key = entry.value.map((s) => s.id).join('>');
      if (!seen.add(key)) continue;
      options.add(
        AwarenessEngine.buildRoute(
          id: 'route_${entry.key.name}',
          flavour: entry.key.flavour,
          segmentIds: entry.value.map((s) => s.id).toList(),
          allReports: reports,
          now: at,
        ),
      );
    }

    return _describe(options);
  }

  static List<RoadSegment> _dijkstra(
    String start,
    String goal,
    double Function(RoadSegment) cost,
  ) {
    final dist = <String, double>{start: 0};
    final prev = <String, ({String node, RoadSegment seg})>{};
    final visited = <String>{};
    final queue = PriorityQueue<({String node, double d})>(
      (a, b) => a.d.compareTo(b.d),
    )..add((node: start, d: 0));

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      if (!visited.add(current.node)) continue;
      if (current.node == goal) break;
      for (final edge in _net.edges[current.node] ?? const <_Edge>[]) {
        if (visited.contains(edge.to)) continue;
        final nd = current.d + cost(edge.segment);
        if (nd < (dist[edge.to] ?? double.infinity)) {
          dist[edge.to] = nd;
          prev[edge.to] = (node: current.node, seg: edge.segment);
          queue.add((node: edge.to, d: nd));
        }
      }
    }

    if (!prev.containsKey(goal) && goal != start) return const [];

    final path = <RoadSegment>[];
    var cursor = goal;
    var guard = 0;
    while (cursor != start && guard++ < 200) {
      final step = prev[cursor];
      if (step == null) return const [];
      path.insert(0, step.seg);
      cursor = step.node;
    }
    return path;
  }

  /// Writes the plain-language tradeoff copy that the route cards show.
  /// Always phrased as "reported", never as a safety guarantee.
  static List<RouteOption> _describe(List<RouteOption> raw) {
    if (raw.isEmpty) return raw;

    final fastest = raw.reduce((a, b) => a.minutes <= b.minutes ? a : b);
    final calmest = raw.reduce((a, b) => a.routeScore <= b.routeScore ? a : b);

    return [
      for (final r in raw)
        RouteOption(
          id: r.id,
          flavour: r.flavour,
          segments: r.segments,
          awareness: r.awareness,
          distanceKm: r.distanceKm,
          baseMinutes: r.baseMinutes,
          totalMinutes: r.totalMinutes,
          routeScore: r.routeScore,
          reports: r.reports,
          explanation: _explain(r, fastest),
          highlights: _highlights(r),
          isRecommended: r.id == calmest.id && raw.length > 1,
          avoidsBlockage: r.avoidsBlockage,
        ),
    ]..sort((a, b) {
        // Fastest first, then the recommended alternative, then the rest.
        if (a.flavour == RouteFlavour.fastest) return -1;
        if (b.flavour == RouteFlavour.fastest) return 1;
        return a.routeScore.compareTo(b.routeScore);
      });
  }

  static String _explain(RouteOption r, RouteOption fastest) {
    final delta = r.minutes - fastest.minutes;
    final avoided = fastest.reports
        .where((f) => !r.reports.any((x) => x.id == f.id))
        .toList();

    final parts = <String>[];
    if (avoided.isNotEmpty) {
      final blocks = avoided
          .where((x) => x.category == ReportCategory.blockageOrClosure)
          .length;
      final lights = avoided
          .where((x) => x.category == ReportCategory.lightingProblem)
          .length;
      final water = avoided
          .where((x) => x.category == ReportCategory.waterOrDrainage)
          .length;
      final safety = avoided
          .where((x) => x.category == ReportCategory.safetyConcern)
          .length;
      if (blocks > 0) parts.add(_plural(blocks, 'blocked-road report'));
      if (lights > 0) parts.add(_plural(lights, 'low-light report'));
      if (water > 0) parts.add(_plural(water, 'water report'));
      if (safety > 0) parts.add(_plural(safety, 'safety-concern report'));
    }

    if (r.id == fastest.id) {
      if (r.reports.isEmpty) {
        return 'Quickest option. No recent community reports on this route.';
      }
      final counts = <String>[];
      if (r.blockageCount > 0) {
        counts.add(_plural(r.blockageCount, 'blockage report'));
      }
      if (r.lightingCount > 0) {
        counts.add(_plural(r.lightingCount, 'lighting report'));
      }
      if (r.waterCount > 0) counts.add(_plural(r.waterCount, 'water report'));
      if (r.safetyCount > 0) {
        counts.add(_plural(r.safetyCount, 'safety-concern report'));
      }
      if (counts.isEmpty) {
        return 'Quickest option. ${_plural(r.reports.length, 'recent report')} on this route.';
      }
      return 'Quickest option, but passes ${_join(counts)}.';
    }

    if (parts.isEmpty) {
      if (delta <= 0) {
        return 'Similar time to the fastest route, with the same reported conditions.';
      }
      return 'Adds ${_mins(delta)} without avoiding any current report.';
    }

    final avoidance = 'avoids ${_join(parts)}';
    if (delta <= 0) {
      return 'Same time or quicker, and $avoidance.';
    }
    return 'Adds ${_mins(delta)} but $avoidance.';
  }

  static List<String> _highlights(RouteOption r) {
    final out = <String>[];
    final darkest = r.awareness.isEmpty
        ? null
        : r.awareness.reduce((a, b) => a.lightingScore >= b.lightingScore ? a : b);

    if (!r.avoidsBlockage) {
      out.add('Passes a segment reported as blocked');
    }
    if (darkest != null && darkest.lightingScore > 0.55) {
      out.add('Low-light stretch on ${darkest.segment.name}');
    }
    if (r.waterCount > 0) {
      out.add('${_plural(r.waterCount, 'water/seepage report')} on route');
    }
    if (r.safetyCount > 0) {
      out.add('${_plural(r.safetyCount, 'safety-concern report')} nearby');
    }
    if (r.reports.isEmpty) {
      out.add('No live reports — limited data');
    }
    final busiest = r.segments.isEmpty
        ? null
        : r.segments.reduce((a, b) => a.activityScore >= b.activityScore ? a : b);
    if (busiest != null && busiest.activityScore > 0.8) {
      out.add('Mostly busy roads (${busiest.name})');
    }
    return out.take(3).toList();
  }

  static String _plural(int n, String noun) =>
      '$n $noun${n == 1 ? '' : 's'}';

  static String _mins(int m) => m == 1 ? '1 minute' : '$m minutes';

  static String _join(List<String> items) {
    if (items.length == 1) return items.first;
    if (items.length == 2) return '${items[0]} and ${items[1]}';
    return '${items.sublist(0, items.length - 1).join(', ')} and ${items.last}';
  }
}

enum _Objective {
  fastest(RouteFlavour.fastest),
  betterLit(RouteFlavour.betterLit),
  fewerHazards(RouteFlavour.fewerHazards);

  const _Objective(this.flavour);
  final RouteFlavour flavour;
}

/// Adjacency list plus the node coordinate table, built as one unit.
class _Network {
  const _Network({required this.edges, required this.points});
  final Map<String, List<_Edge>> edges;
  final Map<String, GeoPoint> points;
}

class _Edge {
  const _Edge(this.segment, this.to);
  final RoadSegment segment;
  final String to;
}

/// Tiny binary heap so the planner needs no extra package.
class PriorityQueue<E> {
  PriorityQueue(this._compare);

  final int Function(E a, E b) _compare;
  final List<E> _items = [];

  bool get isNotEmpty => _items.isNotEmpty;
  int get length => _items.length;

  void add(E value) {
    _items.add(value);
    var i = _items.length - 1;
    while (i > 0) {
      final parent = (i - 1) ~/ 2;
      if (_compare(_items[i], _items[parent]) >= 0) break;
      final tmp = _items[i];
      _items[i] = _items[parent];
      _items[parent] = tmp;
      i = parent;
    }
  }

  E removeFirst() {
    final first = _items.first;
    final last = _items.removeLast();
    if (_items.isNotEmpty) {
      _items[0] = last;
      var i = 0;
      while (true) {
        final l = 2 * i + 1;
        final r = 2 * i + 2;
        var smallest = i;
        if (l < _items.length && _compare(_items[l], _items[smallest]) < 0) {
          smallest = l;
        }
        if (r < _items.length && _compare(_items[r], _items[smallest]) < 0) {
          smallest = r;
        }
        if (smallest == i) break;
        final tmp = _items[i];
        _items[i] = _items[smallest];
        _items[smallest] = tmp;
        i = smallest;
      }
    }
    return first;
  }
}
