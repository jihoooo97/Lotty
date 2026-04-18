import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        MobileAds.shared.start()
        
        notificationCenter.delegate = self
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { _, _ in}
        noticeDrawnDate()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .list, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
    }
    
    private func noticeDrawnDate() {
        notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "\(checkRecentDrawNo())회 번호가 공개되었어요!"
        content.subtitle = ""
        content.body = "QR코드를 사용해서 당첨여부를 확인해보세요."
        content.sound = .default
        
        let dateComponent = DateComponents(
            calendar: .init(identifier: .gregorian),
            timeZone: .init(identifier: "Asia/Seoul"),
            hour: 20,
            minute: 46,
            weekday: 7
        )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "DrawnDateNotice",
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    private func checkRecentDrawNo() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let baseComponents = DateComponents(
            timeZone: .init(identifier: "Asia/Seoul"),
            year: 2002,
            month: 12,
            day: 7,
            hour: 20,
            minute: 45
        )
        
        guard let baseDate = calendar.date(from: baseComponents) else { return 0 }
        
        let timeInterval = Date.now.timeIntervalSince(baseDate)
        let weekSeconds: TimeInterval = 604800
        let fullWeeksPassed = Int(timeInterval / weekSeconds)
    
        return 2 + fullWeeksPassed
    }
    
}
