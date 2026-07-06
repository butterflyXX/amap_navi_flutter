import AMapNaviKit
import Flutter
import UIKit

final class AMapNaviPlatformView: NSObject, FlutterPlatformView {
  private let walkView: AMapNaviWalkView
  private lazy var walkManager = AMapNaviWalkManager.sharedInstance()

  init(frame: CGRect, viewId: Int64) {
    walkView = AMapNaviWalkView(frame: frame)
    super.init()

    walkView.delegate = self
    walkView.showSensorHeading = true
    walkView.showGreyAfterPass = true
    walkManager.addDataRepresentative(walkView)
  }

  deinit {
    print("导航地图组件释放")
    walkManager.removeDataRepresentative(walkView)
    walkView.delegate = nil
  }

  func view() -> UIView {
    return walkView
  }
}

extension AMapNaviPlatformView: AMapNaviWalkViewDelegate {
  func walkViewCloseButtonClicked(_ walkView: AMapNaviWalkView) {
    // View 层只负责 UI 回调，不自动停止全局导航 session。
  }
}
