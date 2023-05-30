import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> startDestinationController =
      TextEditingController().obs;
  Rx<TextEditingController> endDestinationController =
      TextEditingController().obs;
  Rx<GoogleMapController>? googleMapController;
  Rx<LatLng> initialPosition = LatLng(37.7749, -122.4194).obs;
  Rx<Location>? startLocation;
  Rx<Location>? endLocation;
  RxSet<Marker> markers = <Marker>{}.obs;

  // Future<bool?> getCurrentPosition() async {
  //   Location location = Location();
  //   bool serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return false;
  //     }
  //   }
  //   PermissionStatus permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     PermissionStatus permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return exit(0);
  //     }
  //   }
  //   final position = await Location().getLocation();
  //   initialPosition.value =
  //       LatLng(position.latitude ?? 0, position.latitude ?? 0);
  //   return true;
  // }
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
        googleMapController?.value.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: latLng,
              zoom: 18.0,
            ),
          ),
        );
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
    // await getCurrentPosition();
  }
}
