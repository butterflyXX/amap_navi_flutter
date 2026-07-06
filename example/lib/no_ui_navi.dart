import 'package:amap_navi_flutter/amap_navi_flutter.dart';
import 'package:flutter/material.dart';

class NoUINavi extends StatefulWidget {
  const NoUINavi({super.key});

  @override
  State<NoUINavi> createState() => _NoUINaviState();
}

class _NoUINaviState extends State<NoUINavi> {
  bool _isNavigating = false;
  @override
  Widget build(BuildContext context) {
    final text = _isNavigating ? '导航结束' : '开始导航';
    return Column(
      children: [
        Text('无UI导航'),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_isNavigating) {
              await _stopNavi();
              return;
            }
            await _startNavi();
          },
          child: Text(text),
        ),
      ],
    );
  }

  Future<void> _startNavi() async {
    changeNaviState(true);
    await AMapNavigator.initializeNavigationSession();
    final result = await AMapNavigator.calculateWalkRoute(
      start: AMapLatLng(latitude: 39.90872, longitude: 116.39749),
      end: AMapLatLng(latitude: 39.91872, longitude: 116.40749),
    );
    if (!result) {
      changeNaviState(false);
      return;
    }
    await AMapNavigator.startGpsNavi();
  }

  Future<void> _stopNavi() async {
    changeNaviState(false);
    await AMapNavigator.cleanupNavigationSession();
  }

  void changeNaviState(bool isNavigating) {
    setState(() {
      _isNavigating = isNavigating;
    });
  }
}
