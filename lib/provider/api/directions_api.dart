import 'dart:convert';

import 'package:easywalk/model/Trasnport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../../util/global_key.dart';

class DirectionApi {
  static Future<List<Polyline>?> getDirections(
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
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=transit&key=${Secrets.GOOGLE_API_KEY}';
    // HTTP GET 요청 보내고 응답 받기
    final response = await http.get(Uri.parse(url));
    List<Polyline> resultPoly = [];
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
              print(step);
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
              final polyline = step['polyline'];
              var mutipolyline;
              List<PointLatLng> decodedPolyline = [];

              // Remove the leading '{' and trailing '}' if present
              if (polyline['points'].startsWith('{') &&
                  polyline['points'].endsWith('}')) {
                mutipolyline = polyline.substring(1, polyline.length - 1);
                // Split the encoded polyline string by '}' to get individual polyline strings
                List<String> polylineStrings = mutipolyline.split('}');
                // Process each polyline individually
                for (String polylineString in polylineStrings) {
                  // Decode the polyline string
                  decodedPolyline =
                      PolylinePoints().decodePolyline(polylineString);
                }
              } else {
                decodedPolyline =
                    PolylinePoints().decodePolyline(polyline['points']);
              }

              List<LatLng> polylineCoordinates = [];
              for (var point in decodedPolyline) {
                polylineCoordinates
                    .add(LatLng(point.latitude, point.longitude));
              }
              PolylineId id =
                  PolylineId(decodedPolyline[0].latitude.toString());
              Polyline poly = Polyline(
                polylineId: id,
                color: Colors.red,
                points: polylineCoordinates,
                width: 3,
              );
              resultPoly.add(poly);
            }
            return resultPoly;
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
      print(data);
      // 경로 정보 가져오기
      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final route = routes[0];
        print(routes.length);
        final distance = route['distance'];

        print('Distance: $distance meters');
        print('Duration: ${distance ~/ (1.24 * 60)} minutes');
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

  static Future<List<PathInform>?> getPublicDirection(
    Location startLocation,
    Location endLocation,
    int searchType,
  ) async {
    final apiUrl =
        "https://api.odsay.com/v1/api/searchPubTransPathT?OPT=1&SX=${startLocation.longitude}&SY=${startLocation.latitude}&EX=${endLocation.longitude}&EY=${endLocation.latitude}&apiKey=${Secrets.ODSAY_API_KEY}&SearchPathType=$searchType";
    print(apiUrl);
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      // 경로 정보 가져오기
      final routes = data['result']['path'];
      RxList<PathInform> pathInform = <PathInform>[].obs;
      for (final route in routes) {
        List<TransportDetail> detailTransport = [];
        for (final subRoute in route['subPath']) {
          final trafficType = subRoute['trafficType'];
          final sectionTime = subRoute['sectionTime'];
          final startName = subRoute['startName'];
          final endName = subRoute['endName'];
          final distance = subRoute['distance'];
          final subNo = subRoute['lane']?[0]['name'];
          final busNo = subRoute['lane']?[0]['busNo'];

          detailTransport.add(TransportDetail(
              trafficType: trafficType,
              sectionTime: sectionTime,
              startName: startName,
              subNo: subNo,
              busNo: busNo,
              endName: endName,
              distance: distance));
        }
        pathInform.add(PathInform(
            mapObj: route['info']['mapObj'],
            pathType: route['pathType'],
            totalTime: route['info']['totalTime'],
            detail: detailTransport));
      }
      return pathInform;

      if (routes.isNotEmpty) {}
    } else {
      print('Error: ${response.body}');
    }
  }
  //TODO:노선그래픽 데이터 검색
  // static Future<>
}
