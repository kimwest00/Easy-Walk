class PathInform {
  final int pathType;
  final int totalTime;
  final List<TransportDetail>? detail;
  final String? mapObj;

  PathInform(
      {required this.mapObj,
      required this.pathType,
      required this.totalTime,
      required this.detail});
}

class TransportDetail {
  final int trafficType;
  final int sectionTime;
  final String? subNo;
  final String? busNo;
  final String? startName;
  final String? endName;
  final int distance;

  TransportDetail(
      {required this.trafficType,
      required this.sectionTime,
      this.subNo,
      this.busNo,
      required this.startName,
      required this.endName,
      required this.distance});
}
