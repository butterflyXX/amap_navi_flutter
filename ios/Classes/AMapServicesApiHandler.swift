//
//  AMapServicesHandler.swift
//  amap_navi_flutter
//
//  Created by lxc on 2026/7/3.
//
import AMapFoundationKit

final class AMapServicesHandler: NSObject, AMapServicesApi {
  func setAppKey(appKey: String) {
    AMapServices.shared().apiKey = appKey
  }
}
