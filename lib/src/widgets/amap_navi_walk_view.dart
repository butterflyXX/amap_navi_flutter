import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'amap_navi_controller.dart';

class AMapNaviWalkView extends StatefulWidget {
  const AMapNaviWalkView({super.key, required this.onViewCreated});

  final ValueChanged<AMapNaviViewController> onViewCreated;

  @override
  State<AMapNaviWalkView> createState() => _AMapNaviWalkViewState();
}

class _AMapNaviWalkViewState extends State<AMapNaviWalkView> {
  static const String _viewType = 'amap_navi_flutter/navi_view';

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return UiKitView(viewType: _viewType, onPlatformViewCreated: _onPlatformViewCreated);
      case TargetPlatform.android:
        return AndroidView(viewType: _viewType, onPlatformViewCreated: _onPlatformViewCreated);
      default:
        return const SizedBox.shrink();
    }
  }

  void _onPlatformViewCreated(int viewId) {
    widget.onViewCreated(AMapNaviViewController(viewId));
  }
}
