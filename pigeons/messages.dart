import 'package:pigeon/pigeon.dart';

class AMapLatLngDTO {
  double latitude;
  double longitude;
  AMapLatLngDTO({required this.latitude, required this.longitude});
}

class AMapRouteInfoDTO {
  int routeLength;
  int routeTime;
  int routeSegmentCount;
  AMapRouteInfoDTO({required this.routeLength, required this.routeTime, required this.routeSegmentCount});
}

class AMapRouteFailureDTO {
  int code;
  String message;
  AMapRouteFailureDTO({required this.code, required this.message});
}

class AMapNaviInfoDTO {
  int routeRemainDistance;
  int routeRemainTime;
  int segmentRemainDistance;
  int segmentRemainTime;
  AMapNaviInfoDTO({
    required this.routeRemainDistance,
    required this.routeRemainTime,
    required this.segmentRemainDistance,
    required this.segmentRemainTime,
  });
}

class AMapRouteStyleDTO {
  double lineWidth;
  int lineColor;
  bool showStartEndMarker;
  int startMarkerColor;
  int endMarkerColor;
  String startTitle;
  String endTitle;
  Uint8List? textureBytes;
  AMapRouteStyleDTO({
    required this.lineWidth,
    required this.lineColor,
    required this.showStartEndMarker,
    required this.startMarkerColor,
    required this.endMarkerColor,
    required this.startTitle,
    required this.endTitle,
    this.textureBytes,
  });
}

@HostApi()
abstract class AMapNavigatorApi {
  void initializeNavigationSession();
  void cleanupNavigationSession();
  bool calculateWalkRoute(AMapLatLngDTO start, AMapLatLngDTO end);
  void startGpsNavi();
  void stopNavi();
}

@HostApi()
abstract class AMapViewApi {
  bool showCurrentWalkRoute(int viewId, AMapRouteStyleDTO style);
  void clearRoute(int viewId);
}

@FlutterApi()
abstract class AMapNavigatorEventApi {
  void onNaviStarted(int naviMode);
  void onNaviStopped(bool isStopped);
  void onRouteCalculateSuccess(AMapRouteInfoDTO routeInfo);
  void onRouteCalculateFailure(AMapRouteFailureDTO failure);
  void onGpsSignalUpdated(int strength);
  void onRerouteForYaw();
  void onTtsText(String text, int soundType);
  void onNaviInfoUpdated(AMapNaviInfoDTO naviInfo);
}

@HostApi()
abstract class AMapServicesApi {
  void setAppKey(String appKey);
}

@HostApi()
abstract class AMapNaviConfigApi {
  bool areTermsAccepted();
  void setTermsAccepted(bool accepted);
  void updatePrivacyShow(bool hasShow, bool hasContains);
  void updatePrivacyAgree(bool hasAgree);
  void setSpeechRate(double speechRate);
}
