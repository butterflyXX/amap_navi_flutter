import 'dart:typed_data';

import 'package:amap_navi_flutter/src/api/messages.g.dart';

/// 普通地图上绘制导航路线的样式。
class AMapRouteStyle {
  const AMapRouteStyle({
    this.lineWidth = 8,
    this.lineColor = 0xff007aff,
    this.showStartEndMarker = true,
    this.startMarkerColor = 0xff2ecc71,
    this.endMarkerColor = 0xffff3b30,
    this.startTitle = '起点',
    this.endTitle = '终点',
    this.textureBytes,
  });

  /// 路线宽度，单位为 iOS 原生 point。
  final double lineWidth;

  /// 路线颜色，ARGB 格式，例如 0xff007aff。
  final int lineColor;

  /// 是否显示起点和终点标记。
  final bool showStartEndMarker;

  /// 起点标记颜色，ARGB 格式。
  final int startMarkerColor;

  /// 终点标记颜色，ARGB 格式。
  final int endMarkerColor;

  /// 起点标记标题。
  final String startTitle;

  /// 终点标记标题。
  final String endTitle;

  /// 路线纹理图片 bytes。传入后 iOS 会优先使用该图片作为路线纹理。
  final Uint8List? textureBytes;

  AMapRouteStyleDTO toPigeon() {
    return AMapRouteStyleDTO(
      lineWidth: lineWidth,
      lineColor: lineColor,
      showStartEndMarker: showStartEndMarker,
      startMarkerColor: startMarkerColor,
      endMarkerColor: endMarkerColor,
      startTitle: startTitle,
      endTitle: endTitle,
      textureBytes: textureBytes,
    );
  }
}

/// 高德普通地图控制器。
class AMapViewController {
  AMapViewController(this.viewId);

  static final AMapViewApi _api = AMapViewApi();

  /// 原生 PlatformView ID。
  final int viewId;

  /// 在当前地图上绘制最近一次步行算路结果。
  Future<bool> showCurrentWalkRoute({
    AMapRouteStyle style = const AMapRouteStyle(),
  }) {
    return _api.showCurrentWalkRoute(viewId, style.toPigeon());
  }

  /// 清除当前地图上的导航路线。
  Future<void> clearRoute() {
    return _api.clearRoute(viewId);
  }
}
