import 'package:easywalk/modules/splash/controller/splash_controller.dart';
import 'package:easywalk/provider/services/polyline_services.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PolyService());
    Get.put(SplashController());
  }
}
