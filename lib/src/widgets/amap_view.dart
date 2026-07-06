import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'amap_view_controller.dart';

class AMapView extends StatefulWidget {
  const AMapView({super.key, required this.onViewCreated});

  final ValueChanged<AMapViewController> onViewCreated;

  @override
  State<AMapView> createState() => _AMapViewState();
}

class _AMapViewState extends State<AMapView> {
  static const String _viewType = 'amap_navi_flutter/map_view';

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: _viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      case TargetPlatform.android:
        return AndroidView(
          viewType: _viewType,
          onPlatformViewCreated: _onPlatformViewCreated,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _onPlatformViewCreated(int viewId) {
    widget.onViewCreated(AMapViewController(viewId));
  }
}
