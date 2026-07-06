final class AMapPlatformViewProxy {
  weak var value: AMapPlatformView?
  init(_ value: AMapPlatformView) {
    self.value = value
  }
}

final class AMapViewRegistry {
  static let shared = AMapViewRegistry()

  private var views: [Int64: AMapPlatformViewProxy] = [:]

  private init() {}

  func register(_ view: AMapPlatformView, viewId: Int64) {
    views[viewId] = AMapPlatformViewProxy(view)
  }

  func unregister(viewId: Int64) {
    views.removeValue(forKey: viewId)
  }

  func view(for viewId: Int64) -> AMapPlatformView? {
    return views[viewId]?.value
  }
}
