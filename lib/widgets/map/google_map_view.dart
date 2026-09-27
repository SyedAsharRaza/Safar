import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/theme/app_theme.dart';
import '../../models/geo.dart';
import '../../models/safety_report.dart';
import 'map_painter.dart';
import 'marker_factory.dart';

LatLng _ll(GeoPoint p) => LatLng(p.lat, p.lng);

/// The real Google map, exposing the same surface as the painted [MockMap] so
/// the two are interchangeable.
///
/// Reports the moment it decides the map cannot render, so the caller can swap
/// in the painted fallback rather than leaving a grey rectangle on screen.
class GoogleMapView extends StatefulWidget {
  const GoogleMapView({
    super.key,
    required this.bounds,
    this.routeLines = const [],
    this.segmentTints = const [],
    this.reports = const [],
    this.selectedReportId,
    this.origin,
    this.destination,
    this.userLocation,
    this.droppedPin,
    this.onReportTap,
    this.onMapTap,
    this.interactive = true,
    this.onFailed,
    this.obscuredBottom = 0,
  });

  final GeoBounds bounds;
  final List<MapRouteLine> routeLines;
  final List<MapSegmentTint> segmentTints;
  final List<SafetyReport> reports;
  final String? selectedReportId;
  final GeoPoint? origin;
  final GeoPoint? destination;
  final GeoPoint? userLocation;
  final GeoPoint? droppedPin;
  final ValueChanged<SafetyReport>? onReportTap;
  final ValueChanged<GeoPoint>? onMapTap;
  final bool interactive;

  /// Called if the map surface never becomes usable.
  final VoidCallback? onFailed;

  /// Height of any sheet covering the bottom of the map. The camera keeps
  /// content above it instead of centring pins behind the sheet.
  final double obscuredBottom;

  @override
  State<GoogleMapView> createState() => GoogleMapViewState();
}

class GoogleMapViewState extends State<GoogleMapView> {
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  Timer? _readyGuard;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    // If the SDK cannot initialise — key missing, Maps SDK for Android not
    // enabled, no Play Services — onMapCreated never fires. Give it a few
    // seconds, then hand over to the fallback.
    _readyGuard = Timer(const Duration(seconds: 6), () {
      if (!_ready && mounted) widget.onFailed?.call();
    });
  }

  @override
  void didUpdateWidget(GoogleMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reports != widget.reports ||
        oldWidget.selectedReportId != widget.selectedReportId ||
        oldWidget.origin != widget.origin ||
        oldWidget.destination != widget.destination ||
        oldWidget.droppedPin != widget.droppedPin) {
      _rebuildMarkers();
    }
    if (oldWidget.bounds != widget.bounds ||
        oldWidget.obscuredBottom != widget.obscuredBottom ||
        oldWidget.reports.length != widget.reports.length) {
      _fitBounds();
    }
  }

  @override
  void dispose() {
    _readyGuard?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _rebuildMarkers() async {
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final markers = <Marker>{};

    for (final report in widget.reports) {
      final icon = await MarkerFactory.forReport(
        report,
        pixelRatio: ratio,
        selected: report.id == widget.selectedReportId,
      );
      markers.add(
        Marker(
          markerId: MarkerId(report.id),
          position: _ll(report.location),
          icon: icon,
          anchor: MarkerFactory.pinAnchor,
          zIndexInt: report.id == widget.selectedReportId ? 10 : 1,
          onTap: widget.onReportTap == null
              ? null
              : () => widget.onReportTap!(report),
          infoWindow: InfoWindow(
            title: report.specificType.label,
            snippet: report.areaName,
          ),
        ),
      );
    }

    if (widget.origin != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('_origin'),
          position: _ll(widget.origin!),
          icon: await MarkerFactory.endpoint(isOrigin: true, pixelRatio: ratio),
          anchor: MarkerFactory.pinAnchor,
          zIndexInt: 5,
        ),
      );
    }
    if (widget.destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('_destination'),
          position: _ll(widget.destination!),
          icon: await MarkerFactory.endpoint(isOrigin: false, pixelRatio: ratio),
          anchor: MarkerFactory.pinAnchor,
          zIndexInt: 5,
        ),
      );
    }
    if (widget.droppedPin != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('_pin'),
          position: _ll(widget.droppedPin!),
          icon: await MarkerFactory.endpoint(isOrigin: false, pixelRatio: ratio),
          anchor: MarkerFactory.pinAnchor,
          zIndexInt: 8,
        ),
      );
    }

    if (mounted) setState(() => _markers = markers);
  }

  /// Area the app covers, matching the server's own check.
  ///
  /// The camera fits only points inside it. One stray coordinate — a
  /// mis-tapped pin, a bad row from an older client — would otherwise stretch
  /// the bounds across continents and zoom the map out to the ocean.
  static bool _inServiceArea(GeoPoint p) =>
      p.lat >= 28.6 && p.lat <= 30.2 && p.lng >= 70.6 && p.lng <= 72.8;

  Future<void> _fitBounds() async {
    final controller = _controller;
    if (controller == null) return;
    final points = <LatLng>[
      for (final line in widget.routeLines)
        ...line.points.where(_inServiceArea).map(_ll),
      for (final r in widget.reports)
        if (_inServiceArea(r.location)) _ll(r.location),
      if (widget.origin != null && _inServiceArea(widget.origin!))
        _ll(widget.origin!),
      if (widget.destination != null && _inServiceArea(widget.destination!))
        _ll(widget.destination!),
    ];
    if (points.isEmpty) {
      points.addAll([
        LatLng(widget.bounds.south, widget.bounds.west),
        LatLng(widget.bounds.north, widget.bounds.east),
      ]);
    }
    try {
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBoundsFor(points), 56),
      );
    } catch (_) {
      // A bounds update before the surface has a size throws; the initial
      // camera position already frames the area, so this is safe to ignore.
    }
  }

  /// Re-frames the map on the current content. Wired to the recentre control.
  void recentre() => _fitBounds();

  Set<Polyline> _polylines() {
    final lines = <Polyline>{};
    var i = 0;

    for (final tint in widget.segmentTints) {
      final segment = tint.segmentId;
      final geo = _segmentPath(segment);
      if (geo == null) continue;
      lines.add(
        Polyline(
          polylineId: PolylineId('tint_$segment'),
          points: geo.map(_ll).toList(),
          color: tint.color.withValues(alpha: tint.strong ? 0.5 : 0.3),
          width: 7,
          zIndex: 0,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    }

    for (final line in widget.routeLines) {
      if (line.points.length < 2) continue;
      lines.add(
        Polyline(
          polylineId: PolylineId('route_${i++}'),
          points: line.points.map(_ll).toList(),
          color: line.color.withValues(alpha: line.selected ? 1.0 : 0.55),
          width: line.selected ? 8 : 5,
          zIndex: line.selected ? 4 : 2,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          patterns: line.dashed
              ? <PatternItem>[PatternItem.dash(22), PatternItem.gap(12)]
              : const <PatternItem>[],
        ),
      );
    }
    return lines;
  }

  List<GeoPoint>? _segmentPath(String id) {
    // Imported lazily to avoid a cycle with the geography data.
    return _segmentLookup(id);
  }

  @override
  Widget build(BuildContext context) {
    final centre = widget.bounds.center;

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _ll(centre),
        zoom: 13.2,
      ),
      style: context.isDark ? kDarkMapStyle : kLightMapStyle,
      padding: EdgeInsets.only(bottom: widget.obscuredBottom),
      markers: _markers,
      polylines: _polylines(),
      circles: widget.userLocation == null
          ? const {}
          : {
              Circle(
                circleId: const CircleId('_user'),
                center: _ll(widget.userLocation!),
                radius: 70,
                fillColor: context.scheme.primary.withValues(alpha: 0.18),
                strokeColor: context.scheme.primary,
                strokeWidth: 2,
              ),
            },
      onMapCreated: (controller) {
        _ready = true;
        _readyGuard?.cancel();
        _controller = controller;
        _rebuildMarkers();
        WidgetsBinding.instance.addPostFrameCallback((_) => _fitBounds());
        Future<void>.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _fitBounds();
        });
      },
      onTap: widget.onMapTap == null
          ? null
          : (pos) => widget.onMapTap!(GeoPoint(pos.latitude, pos.longitude)),
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: widget.interactive,
      scrollGesturesEnabled: widget.interactive,
      zoomGesturesEnabled: widget.interactive,
      rotateGesturesEnabled: false,
      tiltGesturesEnabled: false,
      liteModeEnabled: false,
    );
  }
}

/// Set by [SafarMap] so this file does not import the geography directly.
List<GeoPoint>? Function(String id) _segmentLookup = (_) => null;

// ignore: use_setters_to_change_properties
void registerSegmentLookup(List<GeoPoint>? Function(String id) lookup) {
  _segmentLookup = lookup;
}
