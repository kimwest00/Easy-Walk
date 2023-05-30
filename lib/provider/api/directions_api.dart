import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../util/global_key.dart';

class DirectionApi {
  static Future<void> getDirections(
    Location startLocation,
    Location endLocation,
  ) async {
    String origin = startLocation.latitude.toString() +
        ',' +
        startLocation.longitude.toString();
    String destination = endLocation.latitude.toString() +
        ',' +
        endLocation.longitude.toString();
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=transit&key=${Secrets.API_KEY}';
    // HTTP GET 요청 보내고 응답 받기
    final response = await http.get(Uri.parse(url));

    // 응답 JSON 파싱
    final data = json.decode(response.body);
    // 대중교통 경로 정보 추출
    final routes = data['routes'];
    if (routes != null && routes.length > 0) {
      final firstRoute = routes[0];
      final legs = firstRoute['legs'];
      if (legs != null && legs.length > 0) {
        final firstLeg = legs[0];
        final steps = firstLeg['steps'];
        if (steps != null && steps.length > 0) {
          for (final step in steps) {
            final travelMode = step['travel_mode'];
            if (travelMode == 'TRANSIT') {
              final transitDetails = step['transit_details'];
              final line = transitDetails['line'];
              final vehicle = line['vehicle'];

              final vehicleName = vehicle['name'];
              final vehicleType = vehicle['type'];
              final departureStop = transitDetails['departure_stop'];
              final departureStopName = departureStop['name'];
              final arrivalStop = transitDetails['arrival_stop'];
              final arrivalStopName = arrivalStop['name'];
              final duration = step['duration'];

              print('탑승: $vehicleType $vehicleName');
              print('출발: $departureStopName');
              print('도착: $arrivalStopName');
              print('시간: $duration');
              print('-----');
            }
          }
        }
      }
    }
  }

  static Future<Polyline?> calculateWalkingRoute(
    Location startLocation,
    Location endLocation,
  ) async {
    final origin = startLocation.longitude.toString() +
        ',' +
        startLocation.latitude.toString();
    final destination = endLocation.longitude.toString() +
        ',' +
        endLocation.latitude.toString();
    final apiUrl =
        "https://router.project-osrm.org/route/v1/walking/$origin;$destination";
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // 경로 정보 가져오기
      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final route = routes[0];
        final distance = route['distance'];
        final duration = route['duration'];

        print('Distance: $distance meters');
        print('Duration: $duration seconds');
        final legs = route['geometry'];
        print(legs);
        List<PointLatLng> decodedPolyline =
            PolylinePoints().decodePolyline(legs);
        List<LatLng> polylineCoordinates = [];
        decodedPolyline.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
          polylineId: id,
          color: Colors.red,
          points: polylineCoordinates,
          width: 3,
        );
        return polyline;
      } else {
        print('No routes found');
      }
    } else {
      print('Error: ${response.body}');
    }
  }
}
