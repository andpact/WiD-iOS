//
//  AppOpenAdUtil.swift
//  WiD
//
//  Created by jjkim on 2023/09/16.
//

import Foundation
import GoogleMobileAds

final class AppOpenAdUtil: NSObject, ObservableObject, GADFullScreenContentDelegate {
    var appOpenAd: GADAppOpenAd?
    var loadTime = Date()
    
    @Published var isShowingSplashView = true
    
    func loadAd() {
        let request = GADRequest()
        GADAppOpenAd.load(
            withAdUnitID: "ca-app-pub-3940256099942544/5662855259", // 앱 오프닝 광고 단위 ID 테스트 용
//            withAdUnitID: "ca-app-pub-3641806776840744/8194193597", // 앱 오프닝 광고 단위 ID
            request: request,
            orientation: UIInterfaceOrientation.portrait,
            completionHandler: { (appOpenAdIn, _) in
                self.appOpenAd = appOpenAdIn
                self.appOpenAd?.fullScreenContentDelegate = self
                self.loadTime = Date()
                print("[OPEN AD] Ad is ready")
                
                self.showAdIfAvailable()
            }
        )
    }
    
    func showAdIfAvailable() {
        if let gOpenAd = self.appOpenAd, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
            print("[OPEN AD] will show ad")
            gOpenAd.present(fromRootViewController: (UIApplication.shared.windows.first?.rootViewController)!)
        } else {
            print("[OPEN AD] failed to load ad")
            isShowingSplashView = false // 앱 열기 광고를 불러오지 못하면 메인화면으로 전환.
            
//            self.loadAd()
        }
    }
    
    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        loadAd()
        print("[OPEN AD] Failed: \(error)")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        isShowingSplashView = false
        
//        loadAd()
        print("[OPEN AD] Ad dismissed")
    }
    
//    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print("[OPEN AD] Ad did present")
//    }
}
