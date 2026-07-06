import Flutter
import UIKit

final class AMapViewFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return AMapPlatformView(frame: frame, viewId: viewId)
  }
}
