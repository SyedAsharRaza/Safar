@Tags(['live'])
library;

import 'package:bahawalpur_safar/data/api/safar_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Parses live API output. A report that lands at (0,0) drags the map camera
/// to the Atlantic, so coordinates are checked rather than assumed.
void main() {
  test('every live report parses to real Bahawalpur coordinates', () async {
    final response = await http
        .get(Uri.parse(
          'https://banao-hackathon-app-backend.vercel.app/api/reports?limit=100',
        ))
        .timeout(const Duration(seconds: 40));

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final raw = (body['data']['reports'] as List).cast<Map<String, dynamic>>();
    expect(raw, isNotEmpty, reason: 'API returned no reports');

    final parsed = raw.map(reportFromJson).toList();

    final broken = parsed
        .where((r) =>
            r.location.lat == 0 ||
            r.location.lng == 0 ||
            r.location.lat < 28 ||
            r.location.lat > 31 ||
            r.location.lng < 70 ||
            r.location.lng > 73)
        .toList();

    expect(
      broken.map((r) => '${r.specificType.wire}@${r.location}').toList(),
      isEmpty,
      reason: 'Reports parsed outside Bahawalpur',
    );

    final blankIds = parsed.where((r) => r.id.isEmpty).toList();
    expect(blankIds, isEmpty, reason: 'Reports parsed with no id');
  });
}
