import Flutter
import UIKit

public class AmapNaviFlutterPlugin: NSObject, FlutterPlugin {

  public static func register(with registrar: FlutterPluginRegistrar) {
    registrar.register(
      AMapViewFactory(),
      withId: "amap_navi_flutter/map_view"
    )
    registrar.register(
      AMapNaviViewFactory(),
      withId: "amap_navi_flutter/navi_view"
    )

    let navigatorEventApi = AMapNavigatorEventApi(
      binaryMessenger: registrar.messenger()
    )
    let navigatorApi = AMapNavigatorApiHandler(eventApi: navigatorEventApi)
    AMapNavigatorApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: navigatorApi
    )

    let mapViewApi = AMapViewApiHandler()
    AMapViewApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: mapViewApi
    )

    let servicesApi = AMapServicesHandler()
    AMapServicesApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: servicesApi
    )

    let naviConfigApi = AMapNaviConfigHandler()
    AMapNaviConfigApiSetup.setUp(
      binaryMessenger: registrar.messenger(),
      api: naviConfigApi
    )
  }
}
