sealed class AMapNavigatorEvent {
  const AMapNavigatorEvent();
}

class AMapNaviStartedEvent extends AMapNavigatorEvent {
  const AMapNaviStartedEvent({
    required this.naviMode,
  });

  final int naviMode;
}

class AMapNaviStoppedEvent extends AMapNavigatorEvent {
  const AMapNaviStoppedEvent({
    required this.isStopped,
  });

  final bool isStopped;
}

class AMapRouteCalculateSuccessEvent extends AMapNavigatorEvent {
  const AMapRouteCalculateSuccessEvent({
    required this.routeLength,
    required this.routeTime,
    required this.routeSegmentCount,
  });

  final int routeLength;
  final int routeTime;
  final int routeSegmentCount;
}

class AMapRouteCalculateFailureEvent extends AMapNavigatorEvent {
  const AMapRouteCalculateFailureEvent({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;
}

class AMapGpsSignalUpdatedEvent extends AMapNavigatorEvent {
  const AMapGpsSignalUpdatedEvent({
    required this.strength,
  });

  final int strength;
}

class AMapRerouteForYawEvent extends AMapNavigatorEvent {
  const AMapRerouteForYawEvent();
}

class AMapTtsTextEvent extends AMapNavigatorEvent {
  const AMapTtsTextEvent({
    required this.text,
    required this.soundType,
  });

  final String text;
  final int soundType;
}

class AMapNaviInfoUpdatedEvent extends AMapNavigatorEvent {
  const AMapNaviInfoUpdatedEvent({
    required this.routeRemainDistance,
    required this.routeRemainTime,
    required this.segmentRemainDistance,
    required this.segmentRemainTime,
  });

  final int routeRemainDistance;
  final int routeRemainTime;
  final int segmentRemainDistance;
  final int segmentRemainTime;
}
