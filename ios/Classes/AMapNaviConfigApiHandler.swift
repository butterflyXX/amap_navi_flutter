//
//  AMapNaviConfigHandler.swift
//  amap_navi_flutter
//
//  Created by lxc on 2026/7/3.
//

import AMapFoundationKit
import AMapNaviKit

final class AMapNaviConfigHandler: NSObject, AMapNaviConfigApi {
  func areTermsAccepted() -> Bool {
    return UserDefaults.standard.bool(forKey: "areTermsAccepted")
  }
  
  func setTermsAccepted(accepted: Bool) {
    UserDefaults.standard.set(accepted, forKey: "areTermsAccepted")
  }
  
  func updatePrivacyShow(hasShow: Bool, hasContains: Bool) {
    AMapNaviManagerConfig.shared().updatePrivacyShow(
      hasShow ? .didShow : .notShow,
      privacyInfo: hasContains ? .didContain : .notContain
    )
  }
  func updatePrivacyAgree(hasAgree: Bool) {
    AMapNaviManagerConfig.shared().updatePrivacyAgree(
      hasAgree ? .didAgree : .notAgree
    )
  }
  func setSpeechRate(speechRate: Double) {
    AMapNaviManagerConfig.shared().speechRate = Float(speechRate)
  }
}
