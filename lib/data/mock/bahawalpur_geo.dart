import '../../models/geo.dart';
import '../../models/road_segment.dart';

/// Hand-built geography for the demo area of Bahawalpur.
///
/// Coordinates are approximate and exist only to make the prototype's mock map
/// and route comparison behave like the real city. They are not survey data.
abstract final class BwpGeo {
  static const GeoPoint cityCentre = GeoPoint(29.3956, 71.6836);

  /// The demo area. Everything the prototype shows lives inside this box.
  static const GeoBounds bounds = GeoBounds(
    south: 29.3520,
    west: 71.6320,
    north: 29.4320,
    east: 71.7520,
  );

  // --- Named junctions -------------------------------------------------------
  static const fawaraChowk = GeoPoint(29.3956, 71.6836);
  static const faridGate = GeoPoint(29.3990, 71.6795);
  static const oneUnitChowk = GeoPoint(29.4012, 71.6882);
  static const railwayStation = GeoPoint(29.3915, 71.6718);
  static const bvhGate = GeoPoint(29.3958, 71.6735);
  static const qamcGate = GeoPoint(29.3946, 71.6716);
  static const dringStadium = GeoPoint(29.3898, 71.6872);
  static const noorMahal = GeoPoint(29.3822, 71.6908);
  static const darbarMahal = GeoPoint(29.3782, 71.6952);
  static const satelliteTown = GeoPoint(29.4032, 71.6962);
  static const modelTownA = GeoPoint(29.4086, 71.6886);
  static const modelTownC = GeoPoint(29.4122, 71.6992);
  static const canttGate = GeoPoint(29.3862, 71.7062);
  static const iubBaghdad = GeoPoint(29.3792, 71.7442);
  static const bypassNorth = GeoPoint(29.4238, 71.7108);
  static const bypassEast = GeoPoint(29.4098, 71.7386);
  static const ahmedpurRoadSouth = GeoPoint(29.3648, 71.7046);
  static const multanRoadNorth = GeoPoint(29.4192, 71.6604);
  static const yazmanRoadSouth = GeoPoint(29.3596, 71.6652);
  static const shahiBazaar = GeoPoint(29.3978, 71.6812);
  static const machhliBazaar = GeoPoint(29.3938, 71.6802);
  static const trustColony = GeoPoint(29.3880, 71.6788);
  static const abbasiaTown = GeoPoint(29.4062, 71.6758);
  static const ghallaMandi = GeoPoint(29.3830, 71.6722);
  static const sherbagh = GeoPoint(29.3906, 71.6796);
  static const airportRoad = GeoPoint(29.3566, 71.7204);
  static const lalSuhanraRoad = GeoPoint(29.4004, 71.7506);

  /// The demo road network. Segment ids are stable so seeded reports can
  /// reference them exactly as a Firestore document would.
  static final List<RoadSegment> segments = [
    // ---- Core city ----------------------------------------------------------
    const RoadSegment(
      id: 'seg_circular_north',
      name: 'Circular Road (north)',
      area: 'Inner city',
      path: [faridGate, GeoPoint(29.4004, 71.6840), oneUnitChowk],
      lengthKm: 1.1,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.80,
      activityScore: 0.88,
      baseConditionScore: 0.78,
    ),
    const RoadSegment(
      id: 'seg_fawara_farid',
      name: 'Farid Gate Road',
      area: 'Inner city',
      path: [fawaraChowk, shahiBazaar, faridGate],
      lengthKm: 0.7,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.74,
      activityScore: 0.95,
      baseConditionScore: 0.66,
    ),
    const RoadSegment(
      id: 'seg_shahi_bazaar',
      name: 'Shahi Bazaar',
      area: 'Inner city',
      path: [shahiBazaar, GeoPoint(29.3958, 71.6808), machhliBazaar],
      lengthKm: 0.5,
      roadClass: RoadClass.lane,
      baseLightingScore: 0.62,
      activityScore: 0.97,
      baseConditionScore: 0.54,
    ),
    const RoadSegment(
      id: 'seg_machhli_lane',
      name: 'Machhli Bazaar lane',
      area: 'Inner city',
      path: [machhliBazaar, GeoPoint(29.3918, 71.6796), sherbagh],
      lengthKm: 0.45,
      roadClass: RoadClass.lane,
      baseLightingScore: 0.40,
      activityScore: 0.58,
      baseConditionScore: 0.46,
    ),

    // ---- Westward: hospital, station, Ghalla Mandi ---------------------------
    const RoadSegment(
      id: 'seg_hospital_road',
      name: 'Hospital Road',
      area: 'BVH / QAMC',
      path: [fawaraChowk, GeoPoint(29.3958, 71.6788), bvhGate],
      lengthKm: 1.0,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.86,
      activityScore: 0.84,
      baseConditionScore: 0.82,
    ),
    const RoadSegment(
      id: 'seg_railway_road',
      name: 'Railway Road',
      area: 'Station area',
      path: [bvhGate, GeoPoint(29.3934, 71.6724), railwayStation],
      lengthKm: 0.6,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.68,
      activityScore: 0.76,
      baseConditionScore: 0.70,
    ),
    const RoadSegment(
      id: 'seg_ghalla_mandi',
      name: 'Ghalla Mandi Road',
      area: 'Ghalla Mandi',
      path: [railwayStation, GeoPoint(29.3868, 71.6714), ghallaMandi],
      lengthKm: 0.9,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.44,
      activityScore: 0.52,
      baseConditionScore: 0.48,
    ),
    const RoadSegment(
      id: 'seg_trust_colony_north',
      name: 'Trust Colony Road (north)',
      area: 'Trust Colony',
      path: [sherbagh, GeoPoint(29.3894, 71.6790), trustColony],
      lengthKm: 0.4,
      roadClass: RoadClass.local,
      baseLightingScore: 0.56,
      activityScore: 0.50,
      baseConditionScore: 0.60,
    ),
    const RoadSegment(
      id: 'seg_trust_colony',
      name: 'Trust Colony Road',
      area: 'Trust Colony',
      path: [trustColony, GeoPoint(29.3852, 71.6756), ghallaMandi],
      lengthKm: 0.7,
      roadClass: RoadClass.local,
      baseLightingScore: 0.52,
      activityScore: 0.46,
      baseConditionScore: 0.58,
    ),
    const RoadSegment(
      id: 'seg_qamc_link',
      name: 'QAMC approach',
      area: 'BVH / QAMC',
      path: [bvhGate, GeoPoint(29.3952, 71.6726), qamcGate],
      lengthKm: 0.3,
      roadClass: RoadClass.local,
      baseLightingScore: 0.84,
      activityScore: 0.80,
      baseConditionScore: 0.82,
    ),
    const RoadSegment(
      id: 'seg_multan_road',
      name: 'Multan Road',
      area: 'Abbasia Town',
      path: [bvhGate, abbasiaTown, GeoPoint(29.4130, 71.6668), multanRoadNorth],
      lengthKm: 3.4,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.82,
      activityScore: 0.74,
      baseConditionScore: 0.86,
    ),
    const RoadSegment(
      id: 'seg_yazman_road',
      name: 'Yazman Road',
      area: 'Yazman side',
      path: [ghallaMandi, GeoPoint(29.3702, 71.6672), yazmanRoadSouth],
      lengthKm: 2.9,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.38,
      activityScore: 0.34,
      baseConditionScore: 0.62,
    ),

    // ---- Northward: Model Town, Satellite Town -------------------------------
    const RoadSegment(
      id: 'seg_model_town_road',
      name: 'Model Town Road',
      area: 'Model Town A',
      path: [oneUnitChowk, GeoPoint(29.4050, 71.6880), modelTownA],
      lengthKm: 0.9,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.88,
      activityScore: 0.70,
      baseConditionScore: 0.88,
    ),
    const RoadSegment(
      id: 'seg_model_town_link',
      name: 'Model Town C link',
      area: 'Model Town C',
      path: [modelTownA, GeoPoint(29.4108, 71.6940), modelTownC],
      lengthKm: 1.1,
      roadClass: RoadClass.local,
      baseLightingScore: 0.80,
      activityScore: 0.58,
      baseConditionScore: 0.84,
    ),
    const RoadSegment(
      id: 'seg_satellite_town',
      name: 'Satellite Town Road',
      area: 'Satellite Town',
      path: [oneUnitChowk, GeoPoint(29.4024, 71.6924), satelliteTown],
      lengthKm: 0.9,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.76,
      activityScore: 0.72,
      baseConditionScore: 0.76,
    ),
    const RoadSegment(
      id: 'seg_satellite_bypass',
      name: 'Satellite Town to Bypass',
      area: 'North edge',
      path: [satelliteTown, modelTownC, GeoPoint(29.4190, 71.7040), bypassNorth],
      lengthKm: 2.6,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.58,
      activityScore: 0.40,
      baseConditionScore: 0.80,
    ),
    const RoadSegment(
      id: 'seg_abbasia_link',
      name: 'Abbasia link road',
      area: 'Abbasia Town',
      path: [abbasiaTown, GeoPoint(29.4074, 71.6822), modelTownA],
      lengthKm: 1.4,
      roadClass: RoadClass.local,
      baseLightingScore: 0.66,
      activityScore: 0.50,
      baseConditionScore: 0.70,
    ),

    // ---- Southward: Noor Mahal, Darbar Mahal, Cantt --------------------------
    const RoadSegment(
      id: 'seg_stadium_road',
      name: 'Stadium Road',
      area: 'Dring Stadium',
      path: [fawaraChowk, GeoPoint(29.3926, 71.6854), dringStadium],
      lengthKm: 0.8,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.72,
      activityScore: 0.66,
      baseConditionScore: 0.74,
    ),
    const RoadSegment(
      id: 'seg_noor_mahal_road',
      name: 'Noor Mahal Road',
      area: 'Noor Mahal',
      path: [dringStadium, GeoPoint(29.3856, 71.6888), noorMahal],
      lengthKm: 0.9,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.84,
      activityScore: 0.62,
      baseConditionScore: 0.86,
    ),
    const RoadSegment(
      id: 'seg_darbar_link',
      name: 'Darbar Mahal link',
      area: 'Darbar Mahal',
      path: [noorMahal, GeoPoint(29.3800, 71.6930), darbarMahal],
      lengthKm: 0.6,
      roadClass: RoadClass.local,
      baseLightingScore: 0.56,
      activityScore: 0.44,
      baseConditionScore: 0.72,
    ),
    const RoadSegment(
      id: 'seg_cantt_road',
      name: 'Cantt Road',
      area: 'Cantonment',
      path: [darbarMahal, GeoPoint(29.3820, 71.7010), canttGate],
      lengthKm: 1.2,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.90,
      activityScore: 0.56,
      baseConditionScore: 0.90,
    ),
    const RoadSegment(
      id: 'seg_cantt_bazaar_lane',
      name: 'Cantt Bazaar lane',
      area: 'Cantonment',
      path: [canttGate, GeoPoint(29.3900, 71.7042), GeoPoint(29.3940, 71.7016)],
      lengthKm: 0.9,
      roadClass: RoadClass.lane,
      baseLightingScore: 0.34,
      activityScore: 0.30,
      baseConditionScore: 0.50,
    ),
    const RoadSegment(
      id: 'seg_ahmedpur_road',
      name: 'Ahmedpur East Road',
      area: 'Southern approach',
      path: [darbarMahal, GeoPoint(29.3714, 71.7000), ahmedpurRoadSouth],
      lengthKm: 1.8,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.46,
      activityScore: 0.38,
      baseConditionScore: 0.72,
    ),
    const RoadSegment(
      id: 'seg_airport_road',
      name: 'Airport Road',
      area: 'Airport side',
      path: [ahmedpurRoadSouth, GeoPoint(29.3596, 71.7124), airportRoad],
      lengthKm: 1.4,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.62,
      activityScore: 0.28,
      baseConditionScore: 0.88,
    ),

    // ---- Eastward: university corridor --------------------------------------
    const RoadSegment(
      id: 'seg_university_road_west',
      name: 'Baghdad-ul-Jadeed Road (west)',
      area: 'University corridor',
      path: [canttGate, GeoPoint(29.3838, 71.7180), GeoPoint(29.3812, 71.7292)],
      lengthKm: 2.4,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.64,
      activityScore: 0.52,
      baseConditionScore: 0.78,
    ),
    const RoadSegment(
      id: 'seg_university_road_east',
      name: 'Baghdad-ul-Jadeed Road (east)',
      area: 'Islamia University',
      path: [GeoPoint(29.3812, 71.7292), GeoPoint(29.3800, 71.7372), iubBaghdad],
      lengthKm: 1.6,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.48,
      activityScore: 0.60,
      baseConditionScore: 0.80,
    ),
    const RoadSegment(
      id: 'seg_university_service_lane',
      name: 'University service lane',
      area: 'Islamia University',
      path: [
        GeoPoint(29.3812, 71.7292),
        GeoPoint(29.3866, 71.7330),
        GeoPoint(29.3884, 71.7420),
      ],
      lengthKm: 1.7,
      roadClass: RoadClass.lane,
      baseLightingScore: 0.22,
      activityScore: 0.18,
      baseConditionScore: 0.44,
    ),
    const RoadSegment(
      id: 'seg_bypass_east',
      name: 'Bahawalpur Bypass (east)',
      area: 'East edge',
      path: [bypassNorth, bypassEast, GeoPoint(29.3950, 71.7450), lalSuhanraRoad],
      lengthKm: 3.6,
      roadClass: RoadClass.arterial,
      baseLightingScore: 0.54,
      activityScore: 0.26,
      baseConditionScore: 0.90,
    ),
    const RoadSegment(
      id: 'seg_lal_suhanra_link',
      name: 'Lal Suhanra link',
      area: 'East edge',
      path: [lalSuhanraRoad, GeoPoint(29.3878, 71.7490), iubBaghdad],
      lengthKm: 1.6,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.36,
      activityScore: 0.22,
      baseConditionScore: 0.76,
    ),
    const RoadSegment(
      id: 'seg_cantt_east_link',
      name: 'Cantt east link',
      area: 'Cantonment',
      path: [
        GeoPoint(29.3940, 71.7016),
        GeoPoint(29.3986, 71.7120),
        bypassEast,
      ],
      lengthKm: 2.8,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.50,
      activityScore: 0.32,
      baseConditionScore: 0.72,
    ),
    const RoadSegment(
      id: 'seg_stadium_cantt_link',
      name: 'Stadium to Cantt link',
      area: 'Cantonment',
      path: [dringStadium, GeoPoint(29.3882, 71.6960), canttGate],
      lengthKm: 1.1,
      roadClass: RoadClass.collector,
      baseLightingScore: 0.60,
      activityScore: 0.48,
      baseConditionScore: 0.70,
    ),
  ];

  static final Map<String, RoadSegment> segmentsById = {
    for (final s in segments) s.id: s,
  };

  static RoadSegment segment(String id) =>
      segmentsById[id] ?? segments.first;

  /// Bahawal Canal, drawn as water on the mock map.
  static const List<GeoPoint> canal = [
    GeoPoint(29.4300, 71.6420),
    GeoPoint(29.4180, 71.6560),
    GeoPoint(29.4060, 71.6640),
    GeoPoint(29.3940, 71.6660),
    GeoPoint(29.3800, 71.6620),
    GeoPoint(29.3660, 71.6520),
    GeoPoint(29.3560, 71.6400),
  ];

  /// Green areas: parks, the zoo, palace gardens, the university campus lawn.
  static const List<({String name, List<GeoPoint> ring})> greenAreas = [
    (
      name: 'Sherbagh',
      ring: [
        GeoPoint(29.3918, 71.6770),
        GeoPoint(29.3918, 71.6806),
        GeoPoint(29.3886, 71.6806),
        GeoPoint(29.3886, 71.6770),
      ]
    ),
    (
      name: 'Noor Mahal gardens',
      ring: [
        GeoPoint(29.3842, 71.6884),
        GeoPoint(29.3842, 71.6936),
        GeoPoint(29.3802, 71.6936),
        GeoPoint(29.3802, 71.6884),
      ]
    ),
    (
      name: 'Dring Stadium',
      ring: [
        GeoPoint(29.3912, 71.6852),
        GeoPoint(29.3912, 71.6894),
        GeoPoint(29.3884, 71.6894),
        GeoPoint(29.3884, 71.6852),
      ]
    ),
    (
      name: 'Cantt grounds',
      ring: [
        GeoPoint(29.3884, 71.7020),
        GeoPoint(29.3884, 71.7096),
        GeoPoint(29.3838, 71.7096),
        GeoPoint(29.3838, 71.7020),
      ]
    ),
    (
      name: 'IUB campus',
      ring: [
        GeoPoint(29.3830, 71.7390),
        GeoPoint(29.3830, 71.7500),
        GeoPoint(29.3752, 71.7500),
        GeoPoint(29.3752, 71.7390),
      ]
    ),
    (
      name: 'Model Town park',
      ring: [
        GeoPoint(29.4106, 71.6862),
        GeoPoint(29.4106, 71.6906),
        GeoPoint(29.4076, 71.6906),
        GeoPoint(29.4076, 71.6862),
      ]
    ),
  ];

  /// Area labels drawn on the mock map at low zoom.
  static const List<({String label, GeoPoint at})> areaLabels = [
    (label: 'INNER CITY', at: GeoPoint(29.3968, 71.6820)),
    (label: 'MODEL TOWN', at: GeoPoint(29.4100, 71.6910)),
    (label: 'SATELLITE TOWN', at: GeoPoint(29.4040, 71.6980)),
    (label: 'CANTONMENT', at: GeoPoint(29.3866, 71.7060)),
    (label: 'ABBASIA TOWN', at: GeoPoint(29.4068, 71.6752)),
    (label: 'TRUST COLONY', at: GeoPoint(29.3874, 71.6770)),
    (label: 'ISLAMIA UNIVERSITY', at: GeoPoint(29.3790, 71.7444)),
    (label: 'GHALLA MANDI', at: GeoPoint(29.3826, 71.6712)),
  ];
}
