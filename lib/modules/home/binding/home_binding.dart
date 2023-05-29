import 'package:easywalk/modules/home/controller/home_controller.dart';
import 'package:easywalk/modules/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
