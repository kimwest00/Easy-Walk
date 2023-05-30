class Path {
  final int pathType;
  final int totalTime;
  final TransportDetail detail;

  Path({required this.pathType, required this.totalTime, required this.detail});
}

class TransportDetail {
  final int trafficType;
  final int sectionTime;
  final String? subNo;
  final String? busNo;
  final String startName;
  final String endName;
  final double distance;

  TransportDetail(
      {required this.trafficType,
      required this.sectionTime,
      this.subNo,
      this.busNo,
      required this.startName,
      required this.endName,
      required this.distance});
}
