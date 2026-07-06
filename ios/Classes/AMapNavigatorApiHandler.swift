//
//  AMapNavigatorMessageHandler.swift
//  amap_navi_flutter
//
//  Created by lxc on 2026/7/2.
//
import AMapFoundationKit
import AMapNaviKit

final class AMapNavigatorApiHandler: NSObject, AMapNavigatorApi {
  
  private lazy var walkManager = AMapNaviWalkManager.sharedInstance()
  private let eventApi: AMapNavigatorEventApi
  
  init(eventApi: AMapNavigatorEventApi) {
    self.eventApi = eventApi
    super.init()
  }
  
  func initializeNavigationSession() {
    walkManager.delegate = self
    walkManager.addDataRepresentative(self)
  }
  func cleanupNavigationSession() {
    walkManager.stopNavi()
    walkManager.removeDataRepresentative(self)
    walkManager.delegate = nil
  }
  
  func calculateWalkRoute(start: AMapLatLngDTO, end: AMapLatLngDTO) -> Bool {
    let startPoint = AMapNaviPoint.location(
      withLatitude: start.latitude,
      longitude: start.longitude
    )
    let endPoint = AMapNaviPoint.location(
      withLatitude: end.latitude,
      longitude: end.longitude
    )
    
    if let startPoint, let endPoint {
      return walkManager.calculateWalkRoute(
        withStart: [startPoint],
        end: [endPoint]
      )
    } else {
      return false
    }
  }
  
  func startGpsNavi() throws {
    guard walkManager.startGPSNavi() == true else {
      throw PigeonError(
        code: "startGpsNaviFailed",
        message: "startGPSNavi failed",
        details: nil
      )
    }
  }
  
  func stopNavi() throws {
    walkManager.stopNavi()
  }
}

extension AMapNavigatorApiHandler: AMapNaviWalkManagerDelegate {
  func walkManager(_ walkManager: AMapNaviWalkManager, didStartNavi naviMode: AMapNaviMode) {
    eventApi.onNaviStarted(naviMode: Int64(naviMode.rawValue)) { _ in }
  }
  
  func walkManager(_ walkManager: AMapNaviWalkManager, didStopNavi isStopped: Bool) {
    eventApi.onNaviStopped(isStopped: isStopped) { _ in }
  }
  
  func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager, calculateRouteResult: AMapNaviCalculateRouteResult) {
    if let aRoute = walkManager.naviRoute {
      let routeInfo = AMapRouteInfoDTO(
        routeLength: Int64(aRoute.routeLength),
        routeTime: Int64(aRoute.routeTime),
        routeSegmentCount: Int64(aRoute.routeSegments.count)
      )
      eventApi.onRouteCalculateSuccess(routeInfo: routeInfo) { _ in }
    }
  }
  
  func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: any Error, calculateRouteResult: AMapNaviCalculateRouteResult) {
    let nsError = error as NSError
    let failure = AMapRouteFailureDTO(
      code: Int64(nsError.code),
      message: error.localizedDescription
    )
    eventApi.onRouteCalculateFailure(failure: failure) { _ in }
  }
  
  func walkManager(_ walkManager: AMapNaviWalkManager, update gpsSignalStrength: AMapNaviGPSSignalStrength) {
    eventApi.onGpsSignalUpdated(strength: Int64(gpsSignalStrength.rawValue)) { _ in }
  }
  
  func walkManagerNeedRecalculateRoute(forYaw walkManager: AMapNaviWalkManager) {
    eventApi.onRerouteForYaw { _ in }
  }
  
  func walkManager(_ walkManager: AMapNaviWalkManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
    eventApi.onTtsText(
      text: soundString,
      soundType: Int64(soundStringType.rawValue)
    ) { _ in }
  }
}

extension AMapNavigatorApiHandler: AMapNaviWalkDataRepresentable {
  func walkManager(_ walkManager: AMapNaviWalkManager, update naviInfo: AMapNaviInfo?) {
    guard let naviInfo else {
      return
    }
    let naviInfoDto = AMapNaviInfoDTO(
      routeRemainDistance: Int64(naviInfo.routeRemainDistance),
      routeRemainTime: Int64(naviInfo.routeRemainTime),
      segmentRemainDistance: Int64(naviInfo.segmentRemainDistance),
      segmentRemainTime: Int64(naviInfo.segmentRemainTime)
    )
    eventApi.onNaviInfoUpdated(naviInfo: naviInfoDto) { _ in }
  }
}
