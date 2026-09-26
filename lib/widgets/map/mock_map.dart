import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../models/geo.dart';
import '../../models/safety_report.dart';
import '../../models/taxonomy.dart';
import 'map_painter.dart';
import 'map_projection.dart';
import 'report_marker.dart';

/// The interactive mock map.
///
/// Pans and zooms, draws the seeded Bahawalpur network, route lines, report pins
/// and trip endpoints, and reports taps back as coordinates so the report flow
/// can drop a pin. No maps SDK, no API key, no billing — and it works offline,
/// which is exactly the fallback the blueprint prefers over a broken
/// integration.
class MockMap extends StatefulWidget {
  const MockMap({
    super.key,
    required this.bounds,
    this.routeLines = const [],
    this.segmentTints = const [],
    this.reports = const [],
    this.selectedReportId,
    this.origin,
    this.destination,
    this.originLabel,
    this.destinationLabel,
    this.userLocation,
    this.droppedPin,
    this.onReportTap,
    this.onMapTap,
    this.interactive = true,
    this.showLabels = true,
    this.compactMarkers = false,
    this.animateRoute = false,
    this.detail = 1.0,
    this.overlayPadding = EdgeInsets.zero,
  });

  final GeoBounds bounds;
  final List<MapRouteLine> routeLines;
  final List<MapSegmentTint> segmentTints;
  final List<SafetyReport> reports;
  final String? selectedReportId;
  final GeoPoint? origin;
  final GeoPoint? destination;
  final String? originLabel;
  final String? destinationLabel;
  final GeoPoint? userLocation;
  final GeoPoint? droppedPin;
  final ValueChanged<SafetyReport>? onReportTap;
  final ValueChanged<GeoPoint>? onMapTap;
  final bool interactive;
  final bool showLabels;
  final bool compactMarkers;
  final bool animateRoute;
  final double detail;

  /// Keeps endpoint labels clear of overlaid sheets and app bars.
  final EdgeInsets overlayPadding;

  @override
  State<MockMap> createState() => MockMapState();
}

class MockMapState extends State<MockMap> with TickerProviderStateMixin {
  final TransformationController _controller = TransformationController();
  late final AnimationController _pulse;
  late final AnimationController _draw;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _draw = AnimationController(vsync: this, duration: Motion.slow);
    if (widget.animateRoute && widget.routeLines.isNotEmpty) {
      _draw.forward();
    } else {
      _draw.value = 1;
    }
  }

  @override
  void didUpdateWidget(MockMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    final old = oldWidget;
    // Re-trace the line whenever the selected route changes.
    if (widget.animateRoute &&
        widget.routeLines.isNotEmpty &&
        _selectionChanged(old.routeLines, widget.routeLines)) {
      _draw.forward(from: 0);
    }
    if (old.bounds != widget.bounds) {
      _controller.value = Matrix4.identity();
    }
  }

  bool _selectionChanged(List<MapRouteLine> a, List<MapRouteLine> b) {
    final sa = a.where((l) => l.selected).map((l) => l.color.toARGB32()).toList();
    final sb = b.where((l) => l.selected).map((l) => l.color.toARGB32()).toList();
    if (sa.length != sb.length) return true;
    for (var i = 0; i < sa.length; i++) {
      if (sa[i] != sb[i]) return true;
    }
    return false;
  }

  /// Resets pan and zoom. Wired to the "recentre" control.
  void recentre() {
    _controller.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _draw.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final proj = MapProjection(bounds: widget.bounds, size: size);

        final content = Stack(
          clipBehavior: Clip.none,
          children: [
            // --- Base city -------------------------------------------------
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: BaseMapPainter(
                    bounds: widget.bounds,
                    tokens: tokens,
                    showLabels: widget.showLabels,
                    tints: widget.segmentTints,
                    detail: widget.detail,
                  ),
                ),
              ),
            ),

            // --- Route lines -----------------------------------------------
            if (widget.routeLines.isNotEmpty)
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: _draw,
                    builder: (context, _) => CustomPaint(
                      painter: RouteLinePainter(
                        bounds: widget.bounds,
                        lines: widget.routeLines,
                        tokens: tokens,
                        progress: Curves.easeOutCubic.transform(_draw.value),
                      ),
                    ),
                  ),
                ),
              ),

            // --- Live location dot ------------------------------------------
            if (widget.userLocation != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, _) => CustomPaint(
                      painter: UserDotPainter(
                        bounds: widget.bounds,
                        at: widget.userLocation!,
                        pulse: _pulse.value,
                        color: context.scheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

            // --- Report pins -------------------------------------------------
            for (final report in _orderedReports)
              _pin(
                proj.toOffset(report.location),
                ReportMarker(
                  report: report,
                  selected: report.id == widget.selectedReportId,
                  compact: widget.compactMarkers,
                  onTap: widget.onReportTap == null
                      ? null
                      : () => widget.onReportTap!(report),
                ),
              ),

            // --- Trip endpoints ----------------------------------------------
            if (widget.origin != null)
              _pin(
                proj.toOffset(widget.origin!),
                EndpointMarker(isOrigin: true, label: widget.originLabel),
                anchorBottom: true,
              ),
            if (widget.destination != null)
              _pin(
                proj.toOffset(widget.destination!),
                EndpointMarker(isOrigin: false, label: widget.destinationLabel),
                anchorBottom: true,
              ),

            // --- Dropped pin (report location picker) -------------------------
            if (widget.droppedPin != null)
              _pin(
                proj.toOffset(widget.droppedPin!),
                _DroppedPin(color: context.scheme.primary),
                anchorBottom: true,
              ),
          ],
        );

        final tappable = widget.onMapTap == null
            ? content
            : GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTapUp: (details) {
                  widget.onMapTap!(proj.toGeo(details.localPosition));
                },
                child: content,
              );

        if (!widget.interactive) {
          return ClipRect(child: tappable);
        }

        return ClipRect(
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1.0,
            maxScale: 4.0,
            boundaryMargin: const EdgeInsets.all(48),
            clipBehavior: Clip.none,
            child: tappable,
          ),
        );
      },
    );
  }

  /// Southern pins are drawn last so they overlap northern ones naturally, and
  /// the selected pin always wins.
  List<SafetyReport> get _orderedReports {
    final list = [...widget.reports]
      ..sort((a, b) => b.location.lat.compareTo(a.location.lat));
    final selected = list.where((r) => r.id == widget.selectedReportId).toList();
    if (selected.isEmpty) return list;
    return [
      ...list.where((r) => r.id != widget.selectedReportId),
      ...selected,
    ];
  }

  Widget _pin(Offset at, Widget child, {bool anchorBottom = false}) {
    // Marker art is anchored at its point, not its centre.
    return Positioned(
      left: at.dx - 60,
      top: anchorBottom ? at.dy - 74 : at.dy - 40,
      width: 120,
      height: anchorBottom ? 78 : 80,
      child: Align(
        alignment:
            anchorBottom ? Alignment.bottomCenter : Alignment.center,
        child: child,
      ),
    );
  }
}

class _DroppedPin extends StatelessWidget {
  const _DroppedPin({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.place, size: 16, color: Colors.white),
        ),
        Container(
          width: 3,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: Radii.pill,
          ),
        ),
      ],
    );
  }
}

/// Builds the segment tints for a set of reports, so elevated stretches of road
/// are visible on the map itself.
List<MapSegmentTint> tintsForReports(List<SafetyReport> reports) {
  final bySegment = <String, List<SafetyReport>>{};
  for (final r in reports.where((r) => r.isLive)) {
    (bySegment[r.roadSegmentId] ??= []).add(r);
  }
  return [
    for (final entry in bySegment.entries)
      MapSegmentTint(
        segmentId: entry.key,
        color: entry.value
            .reduce((a, b) => a.effectiveWeight >= b.effectiveWeight ? a : b)
            .category
            .color,
        strong: entry.value.any(
          (r) =>
              r.specificType == SpecificType.roadBlockage ||
              r.specificType == SpecificType.roadClosed,
        ),
      ),
  ];
}
