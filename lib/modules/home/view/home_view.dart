import 'package:easywalk/modules/home/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        // onMapCreated: ((GoogleMapController controller) {}),
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // 초기 지도 위치 설정
          zoom: 13.0,
        ),
      ),
    );
  }
}
