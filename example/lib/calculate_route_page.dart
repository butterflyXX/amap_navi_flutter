import 'package:amap_navi_flutter/amap_navi_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculateRoutePage extends StatefulWidget {
  const CalculateRoutePage({super.key});

  @override
  State<CalculateRoutePage> createState() => _CalculateRoutePageState();
}

class _CalculateRoutePageState extends State<CalculateRoutePage> {
  final _startLatLng = AMapLatLng(latitude: 39.90872, longitude: 116.39749);
  final _endLatLng = AMapLatLng(latitude: 39.90872, longitude: 116.49749);
  AMapViewController? _mapController;
  bool _hasCalculated = false;

  @override
  void initState() {
    AMapNavigator.initializeNavigationSession();
    super.initState();
  }

  @override
  void dispose() {
    AMapNavigator.cleanupNavigationSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('计算路线')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AMapView(onViewCreated: (controller) => _mapController = controller),
          _buildLatLngWidget(),
        ],
      ),
    );
  }

  Widget _buildLatLngWidget() {
    return SafeArea(
      child: Column(
        children: [
          Text('起点: ${_startLatLng.latitude}, ${_startLatLng.longitude}'),
          Text('终点: ${_endLatLng.latitude}, ${_endLatLng.longitude}'),
          if (!_hasCalculated)
            ElevatedButton(
              onPressed: () {
                _calculateRoute();
              },
              child: const Text('计算并绘制路线'),
            )
          else
            ElevatedButton(
              onPressed: () {
                _mapController?.clearRoute();
                _setHasCalculated(false);
              },
              child: const Text('清除路线'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              AMapNavigator.startGpsNavi();
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AMapNaviWalkView(onViewCreated: (controller) {})),
              );
              AMapNavigator.stopNavi();
            },
            child: const Text('开始导航'),
          ),
        ],
      ),
    );
  }

  Future<void> _calculateRoute() async {
    final result = await AMapNavigator.calculateWalkRoute(start: _startLatLng, end: _endLatLng);
    if (!mounted) return;
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('路线计算失败')));
      return;
    }

    final textureData = await rootBundle.load('assets/image/traffic_texture_smooth.png');
    final textureBytes = textureData.buffer.asUint8List(textureData.offsetInBytes, textureData.lengthInBytes);

    final isRouteShown =
        await _mapController?.showCurrentWalkRoute(
          style: AMapRouteStyle(
            lineWidth: 10,
            lineColor: 0xff1677ff,
            startMarkerColor: 0xff00c853,
            endMarkerColor: 0xffff3d00,
            textureBytes: textureBytes,
          ),
        ) ??
        false;
    if (!mounted) return;
    if (!isRouteShown) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('路线绘制失败')));
    }

    _setHasCalculated(true);
  }

  void _setHasCalculated(bool value) {
    setState(() {
      _hasCalculated = value;
    });
  }
}
