import AMapNaviKit

final class AMapViewApiHandler: NSObject, AMapViewApi {
  func showCurrentWalkRoute(viewId: Int64, style: AMapRouteStyleDTO) throws -> Bool {
    guard let mapView = AMapViewRegistry.shared.view(for: viewId) else {
      throw PigeonError(
        code: "mapViewNotFound",
        message: "AMapView not found for viewId: \(viewId)",
        details: nil
      )
    }

    return mapView.showCurrentWalkRoute(style: style)
  }

  func clearRoute(viewId: Int64) throws {
    guard let mapView = AMapViewRegistry.shared.view(for: viewId) else {
      throw PigeonError(
        code: "mapViewNotFound",
        message: "AMapView not found for viewId: \(viewId)",
        details: nil
      )
    }

    mapView.clearRoute()
  }
}
