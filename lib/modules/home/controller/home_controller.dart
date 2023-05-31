import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../../../model/Trasnport.dart';
import '../../../provider/api/directions_api.dart';

class HomeController extends GetxController {
  Rx<bool> isOnBoarding = true.obs;
  Rx<TextEditingController> startDestinationController =
      TextEditingController().obs;
  Rx<TextEditingController> endDestinationController =
      TextEditingController().obs;
  GoogleMapController? googleMapController;
  Rx<LatLng> initialPosition = LatLng(37.7749, -122.4194).obs;
  Location? startLocation;
  Location? endLocation;
  RxInt selectType = 0.obs;
  RxList<PathInform>? transportList = <PathInform>[].obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  RxMap<PolylineId, Polyline> polylines = <PolylineId, Polyline>{}.obs;

  Future<void> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18.0,
          ),
        ),
      );
    }).catchError((e) {
      Fluttertoast.showToast(msg: e);
    });
  }

  Future<Location?> convertAddressToCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        //TODO: Location가 여러개나올경우 리스트 형식으로 보여주는 화면이 있어야
        Fluttertoast.showToast(msg: locations[0].latitude.toString());
        var location = '(${locations[0].latitude}, ${locations[0].longitude})';
        var latLng = LatLng(locations[0].latitude, locations[0].longitude);
        initialPosition.value = latLng;
        Marker startMarker = Marker(
          markerId: MarkerId(location),
          position: LatLng(locations[0].latitude, locations[0].longitude),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: location,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );
        markers.add(startMarker);
        googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 17.0,
            ),
          ),
        );
        Logger().d(googleMapController);
        return locations[0];
      } else {
        Fluttertoast.showToast(msg: "해당하는 장소가 없습니다. 다시 검색해주세요");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return null;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    var markers = await DirectionApi.getOldmanZone();
    markers.forEach((element) {
      markers.add(element);
    });
    print(markers);
    // await getCurrentPosition();
  }
}
