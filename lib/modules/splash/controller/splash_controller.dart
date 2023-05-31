import 'package:get/get.dart';

class SplashController extends GetxController {
  List<String> titleList = [
    "네비게이션 서비스를 제공합니다!",
    "편리한 예상시간 정보 제공",
    "분석 데이터로 거리를 안전하게"
  ];
  List<String> contentList = [
    "출발지와 도착지를 설정하고 검색하면 지도와\n 함께 편리한 이동수단과 경로를 알려줍니다.",
    "경로 방식에 대한 예상 시간을 예측하기\n때문에 편리한 이용이 가능합니다.",
    "승 하차 혼잡 구역, 노인 사고 다발 구역을\n알려줄 뿐만 아니라 보호구역까지 표시해\n안전하게 이동할 수 있도록 해줍니다."
  ];
  RxBool isLast = false.obs;
}
