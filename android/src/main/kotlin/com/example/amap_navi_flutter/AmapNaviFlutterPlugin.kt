package com.example.amap_navi_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** AmapNaviFlutterPlugin */
class AmapNaviFlutterPlugin :
    FlutterPlugin,
    AMapNavigatorApi {
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        AMapNavigatorApi.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun initializeNavigationSession() {
    }

    override fun cleanupNavigationSession() {
    }

    override fun calculateWalkRoute(
        start: AMapLatLngDTO,
        end: AMapLatLngDTO
    ): Boolean {
        return false
    }

    override fun startGpsNavi() {
    }

    override fun stopNavi() {
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        AMapNavigatorApi.setUp(binding.binaryMessenger, null)
    }
}
