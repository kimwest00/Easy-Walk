import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> startDestinationController =
      TextEditingController().obs;
  Rx<TextEditingController> endDestinationController =
      TextEditingController().obs;
  // Rx<GoogleMapController> googleMapController = GoogleMapController
  Rx<LatLng> initialPosition = LatLng(37.7749, -122.4194).obs;
  Future<bool?> getCurrentPosition() async {
    Location location = Location();
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      PermissionStatus permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return exit(0);
      }
    }
    final position = await Location().getLocation();
    initialPosition.value =
        LatLng(position.latitude ?? 0, position.latitude ?? 0);
    return true;
  }

  @override
  void onInit() async {
    super.onInit();
    // await getCurrentPosition();
  }
}
