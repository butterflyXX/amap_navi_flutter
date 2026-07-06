import 'package:flutter/foundation.dart';

import 'messages.g.dart';
import 'dart:async';
import 'package:amap_navi_flutter/src/types/types.dart';

/// 高德导航管理类。
class AMapNavigator {
  AMapNavigator._();

  static final AMapNavigatorApi _api = AMapNavigatorApi();
  static final StreamController<AMapNavigatorEvent> _eventController = StreamController<AMapNavigatorEvent>.broadcast();
  static var _hasEventApiSetUp = false;

  /// 原生导航回调事件流。
  static Stream<AMapNavigatorEvent> get events => _eventController.stream;

  static void _ensureEventApiSetUp() {
    if (_hasEventApiSetUp) return;
    _hasEventApiSetUp = true;
    AMapNavigatorEventApi.setUp(AMapNavigatorEventApiImpl(_eventController));

    // TODO: 临时用来显示event
    events.listen((event) {
      debugPrint('event: $event');
    });
  }

  /// 初始化导航会话。
  static Future<void> initializeNavigationSession() async {
    _ensureEventApiSetUp();
    return _api.initializeNavigationSession();
  }

  /// 停止导航会话。
  static Future<void> cleanupNavigationSession() async {
    return _api.cleanupNavigationSession();
  }

  /// 计算步行路线。
  static Future<bool> calculateWalkRoute({required AMapLatLng start, required AMapLatLng end}) async {
    final routeResultFuture = waitEvent(
      (event) => event is AMapRouteCalculateSuccessEvent || event is AMapRouteCalculateFailureEvent,
    );
    final result = await _api.calculateWalkRoute(
      AMapLatLngDTO(latitude: start.latitude, longitude: start.longitude),
      AMapLatLngDTO(latitude: end.latitude, longitude: end.longitude),
    );
    if (!result) {
      unawaited(routeResultFuture.then<void>((_) {}, onError: (_) {}));
      return false;
    }
    final event = await routeResultFuture;
    if (event is AMapRouteCalculateSuccessEvent) {
      return true;
    } else {
      return false;
    }
  }

  /// 开始 GPS 导航。
  static Future<void> startGpsNavi() async {
    return _api.startGpsNavi();
  }

  /// 停止导航。
  static Future<void> stopNavi() async {
    return _api.stopNavi();
  }

  static Future<AMapNavigatorEvent> waitEvent(
    bool Function(AMapNavigatorEvent event) test, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return events.where(test).first.timeout(timeout);
  }
}

class AMapNavigatorEventApiImpl implements AMapNavigatorEventApi {
  AMapNavigatorEventApiImpl(this._eventController);

  final StreamController<AMapNavigatorEvent> _eventController;

  @override
  void onNaviStarted(int naviMode) {
    _eventController.add(AMapNaviStartedEvent(naviMode: naviMode));
  }

  @override
  void onNaviStopped(bool isStopped) {
    _eventController.add(AMapNaviStoppedEvent(isStopped: isStopped));
  }

  @override
  void onRouteCalculateSuccess(AMapRouteInfoDTO routeInfo) {
    _eventController.add(
      AMapRouteCalculateSuccessEvent(
        routeLength: routeInfo.routeLength,
        routeTime: routeInfo.routeTime,
        routeSegmentCount: routeInfo.routeSegmentCount,
      ),
    );
  }

  @override
  void onRouteCalculateFailure(AMapRouteFailureDTO failure) {
    _eventController.add(AMapRouteCalculateFailureEvent(code: failure.code, message: failure.message));
  }

  @override
  void onGpsSignalUpdated(int strength) {
    _eventController.add(AMapGpsSignalUpdatedEvent(strength: strength));
  }

  @override
  void onRerouteForYaw() {
    _eventController.add(const AMapRerouteForYawEvent());
  }

  @override
  void onTtsText(String text, int soundType) {
    _eventController.add(AMapTtsTextEvent(text: text, soundType: soundType));
  }

  @override
  void onNaviInfoUpdated(AMapNaviInfoDTO naviInfo) {
    _eventController.add(
      AMapNaviInfoUpdatedEvent(
        routeRemainDistance: naviInfo.routeRemainDistance,
        routeRemainTime: naviInfo.routeRemainTime,
        segmentRemainDistance: naviInfo.segmentRemainDistance,
        segmentRemainTime: naviInfo.segmentRemainTime,
      ),
    );
  }
}
