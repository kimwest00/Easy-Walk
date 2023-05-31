import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolyService extends GetxService {
  static PolyService get to => Get.find();
  RxMap<PolylineId, Polyline> polylines = <PolylineId, Polyline>{}.obs;
  GoogleMapController? googleMapController;
}
