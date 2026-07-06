import Flutter
import AMapNaviKit
import UIKit

private struct MapCameraState {
  let centerCoordinate: CLLocationCoordinate2D
  let zoomLevel: CGFloat
  let rotationDegree: CGFloat
  let cameraDegree: CGFloat
}

final class AMapPlatformView: NSObject, FlutterPlatformView {
  private let mapView: MAMapView
  private let viewId: Int64
  private lazy var walkManager = AMapNaviWalkManager.sharedInstance()
  private var routePolyline: MAPolyline?
  private var currentRouteStyle: AMapRouteStyleDTO?
  private var startAnnotation: MAPointAnnotation?
  private var endAnnotation: MAPointAnnotation?
  private var cameraStateBeforeShowingRoute: MapCameraState?
  
  init(frame: CGRect, viewId: Int64) {
    self.viewId = viewId
    mapView = MAMapView(frame: frame)
    super.init()
    mapView.delegate = self
    AMapViewRegistry.shared.register(self, viewId: viewId)
  }
  
  func view() -> UIView {
    return mapView
  }
  
  func showCurrentWalkRoute(style: AMapRouteStyleDTO) -> Bool {
    guard let naviRoute = walkManager.naviRoute else {
      return false
    }
    
    let routeCoordinates = naviRoute.routeCoordinates
    guard routeCoordinates.count > 1 else {
      return false
    }
    
    clearRoute()
    
    cameraStateBeforeShowingRoute = MapCameraState(
      centerCoordinate: mapView.centerCoordinate,
      zoomLevel: mapView.zoomLevel,
      rotationDegree: mapView.rotationDegree,
      cameraDegree: mapView.cameraDegree
    )
    
    var coordinates = routeCoordinates.map {
      CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
    }
    
    let newPolyline: MAPolyline? = coordinates.withUnsafeMutableBufferPointer { buffer in
      guard let baseAddress = buffer.baseAddress else {
        return nil
      }
      return MAPolyline(coordinates: baseAddress, count: UInt(buffer.count))
    }
    
    guard let polyline = newPolyline else {
      return false
    }
    
    routePolyline = polyline
    currentRouteStyle = style
    if style.showStartEndMarker {
      showStartEndMarkers(routeCoordinates: routeCoordinates, style: style)
    }
    mapView.add(polyline)
    mapView.showOverlays([polyline], edgePadding: UIEdgeInsets(top: 80, left: 40, bottom: 80, right: 40), animated: true)
    return true
  }
  
  func clearRoute() {
    if let routePolyline {
      mapView.remove(routePolyline)
      self.routePolyline = nil
    }

    if let startAnnotation {
      mapView.removeAnnotation(startAnnotation)
      self.startAnnotation = nil
    }

    if let endAnnotation {
      mapView.removeAnnotation(endAnnotation)
      self.endAnnotation = nil
    }

    currentRouteStyle = nil
    
    if let cameraStateBeforeShowingRoute {
      mapView.centerCoordinate = cameraStateBeforeShowingRoute.centerCoordinate
      mapView.setZoomLevel(cameraStateBeforeShowingRoute.zoomLevel, animated: true)
      mapView.setRotationDegree(cameraStateBeforeShowingRoute.rotationDegree, animated: true, duration: 0.25)
      mapView.setCameraDegree(cameraStateBeforeShowingRoute.cameraDegree, animated: true, duration: 0.25)
      self.cameraStateBeforeShowingRoute = nil
    }
  }

  private func showStartEndMarkers(routeCoordinates: [AMapNaviPoint], style: AMapRouteStyleDTO) {
    guard let startPoint = routeCoordinates.first, let endPoint = routeCoordinates.last else {
      return
    }

    let startAnnotation = MAPointAnnotation()
    startAnnotation.coordinate = CLLocationCoordinate2D(
      latitude: startPoint.latitude,
      longitude: startPoint.longitude
    )
    startAnnotation.title = style.startTitle

    let endAnnotation = MAPointAnnotation()
    endAnnotation.coordinate = CLLocationCoordinate2D(
      latitude: endPoint.latitude,
      longitude: endPoint.longitude
    )
    endAnnotation.title = style.endTitle

    self.startAnnotation = startAnnotation
    self.endAnnotation = endAnnotation
    mapView.addAnnotations([startAnnotation, endAnnotation])
  }

  private func color(from argb: Int64) -> UIColor {
    let alpha = CGFloat((argb >> 24) & 0xff) / 255.0
    let red = CGFloat((argb >> 16) & 0xff) / 255.0
    let green = CGFloat((argb >> 8) & 0xff) / 255.0
    let blue = CGFloat(argb & 0xff) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }

  private func makeMarkerImage(color: UIColor) -> UIImage {
    let size = CGSize(width: 22, height: 22)
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { context in
      let rect = CGRect(x: 2, y: 2, width: 18, height: 18)
      color.setFill()
      UIColor.white.setStroke()
      context.cgContext.setLineWidth(3)
      context.cgContext.fillEllipse(in: rect)
      context.cgContext.strokeEllipse(in: rect)
    }
  }
  
  deinit {
    AMapViewRegistry.shared.unregister(viewId: viewId)
    mapView.delegate = nil
    print("地图组件释放")
  }
}

extension AMapPlatformView: MAMapViewDelegate {
  func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
    guard let polyline = overlay as? MAPolyline, polyline == routePolyline else {
      return nil
    }
    
    let renderer = MAPolylineRenderer(polyline: polyline)
    renderer?.lineWidth = CGFloat(currentRouteStyle?.lineWidth ?? 8)
    renderer?.strokeColor = color(from: currentRouteStyle?.lineColor ?? 0xff007aff)
    if let textureData = currentRouteStyle?.textureBytes?.data,
       let textureImage = UIImage(data: textureData) {
      renderer?.strokeImage = textureImage
    }
    return renderer
  }

  func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
    if annotation === startAnnotation {
      let annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: "amap_navi_start_marker")
      annotationView?.image = makeMarkerImage(color: color(from: currentRouteStyle?.startMarkerColor ?? 0xff2ecc71))
      annotationView?.centerOffset = CGPoint(x: 0, y: -11)
      annotationView?.canShowCallout = true
      return annotationView
    }

    if annotation === endAnnotation {
      let annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: "amap_navi_end_marker")
      annotationView?.image = makeMarkerImage(color: color(from: currentRouteStyle?.endMarkerColor ?? 0xffff3b30))
      annotationView?.centerOffset = CGPoint(x: 0, y: -11)
      annotationView?.canShowCallout = true
      return annotationView
    }

    return nil
  }
}
