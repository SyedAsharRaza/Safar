import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../data/mock/bahawalpur_geo.dart';
import '../../models/geo.dart';
import '../../models/safety_report.dart';
import '../../state/app_state.dart';
import '../common/badges.dart';
import 'google_map_view.dart';
import 'map_painter.dart';
import 'mock_map.dart';
import '../../l10n/app_localizations.dart';

/// Which map surface to render.
enum MapMode {
  auto('Automatic', 'Google Maps, with the designed map as a fallback'),
  google('Google Maps', 'Always use the live Google map'),
  designed('Designed map', 'Always use the offline painted map');

  const MapMode(this.label, this.detail);
  final String label;
  final String detail;
}

/// The map used throughout the app.
///
/// Renders a live Google map where it can, and the painted [MockMap] where it
/// cannot — a missing key, Maps SDK for Android not enabled, no Play Services,
/// or no network. The blueprint is explicit that a polished designed map beats
/// a broken API integration, so the fallback is automatic and silent rather
/// than a grey rectangle.
class SafarMap extends StatefulWidget {
  const SafarMap({
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

    /// Small previews stay on the painted map: spinning up a Maps surface for a
    /// 150px thumbnail is slow and costs a map load.
    this.preferDesigned = false,
    this.showBadge = false,
    this.obscuredBottom = 0,
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
  final bool preferDesigned;

  /// Surfaces a chip when the map has *fallen back* to the designed surface, so
  /// an unexpected fallback is never mistaken for a broken Google map. When
  /// Google Maps is working the chip stays hidden — the map speaks for itself.
  final bool showBadge;

  /// Height of any sheet covering the bottom of the map.
  final double obscuredBottom;

  @override
  State<SafarMap> createState() => SafarMapState();
}

class SafarMapState extends State<SafarMap> {
  final GlobalKey<MockMapState> _mockKey = GlobalKey<MockMapState>();
  final GlobalKey<GoogleMapViewState> _googleKey =
      GlobalKey<GoogleMapViewState>();

  /// Set once a Google surface has failed, so we do not thrash between the two.
  static bool _googleUnavailable = false;

  bool _fellBack = false;

  @override
  void initState() {
    super.initState();
    // Lets the Google view resolve segment geometry without importing the
    // geography data directly.
    registerSegmentLookup((id) => BwpGeo.segmentsById[id]?.path);
  }

  bool _useGoogle(AppState app) {
    if (widget.preferDesigned) return false;
    return switch (app.mapMode) {
      MapMode.designed => false,
      MapMode.google => true,
      MapMode.auto => !_googleUnavailable && !_fellBack,
    };
  }

  /// Re-frames the map. Works for whichever surface is live.
  void recentre() {
    _googleKey.currentState?.recentre();
    _mockKey.currentState?.recentre();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final useGoogle = _useGoogle(app);

    final map = useGoogle
        ? GoogleMapView(
            key: _googleKey,
            bounds: widget.bounds,
            routeLines: widget.routeLines,
            segmentTints: widget.segmentTints,
            reports: widget.reports,
            selectedReportId: widget.selectedReportId,
            origin: widget.origin,
            destination: widget.destination,
            userLocation: widget.userLocation,
            droppedPin: widget.droppedPin,
            onReportTap: widget.onReportTap,
            onMapTap: widget.onMapTap,
            interactive: widget.interactive,
            obscuredBottom: widget.obscuredBottom,
            onFailed: () {
              if (!mounted) return;
              _googleUnavailable = true;
              setState(() => _fellBack = true);
            },
          )
        : MockMap(
            key: _mockKey,
            bounds: widget.bounds,
            routeLines: widget.routeLines,
            segmentTints: widget.segmentTints,
            reports: widget.reports,
            selectedReportId: widget.selectedReportId,
            origin: widget.origin,
            destination: widget.destination,
            originLabel: widget.originLabel,
            destinationLabel: widget.destinationLabel,
            userLocation: widget.userLocation,
            droppedPin: widget.droppedPin,
            onReportTap: widget.onReportTap,
            onMapTap: widget.onMapTap,
            interactive: widget.interactive,
            showLabels: widget.showLabels,
            compactMarkers: widget.compactMarkers,
            animateRoute: widget.animateRoute,
            detail: widget.detail,
          );

    // Only worth saying something when the surface is not what was asked for.
    final fellBackUnexpectedly =
        widget.showBadge && !useGoogle && app.mapMode == MapMode.auto;
    if (!fellBackUnexpectedly) return map;

    return Stack(
      children: [
        Positioned.fill(child: map),
        Positioned(
          left: Gap.md,
          top: Gap.md,
          child: Pill(
            label: L.of(context).offlineMap,
            icon: Icons.brush_outlined,
            color: context.tokens.textSecondary,
            background: context.scheme.surface.withValues(alpha: 0.94),
            dense: true,
          ),
        ),
      ],
    );
  }
}
