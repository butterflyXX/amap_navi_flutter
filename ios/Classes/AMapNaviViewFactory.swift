import Flutter
import UIKit

final class AMapNaviViewFactory: NSObject, FlutterPlatformViewFactory {
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return AMapNaviPlatformView(frame: frame, viewId: viewId)
  }
}
