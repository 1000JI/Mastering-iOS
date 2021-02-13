//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import UserNotifications

struct ActionIdentifier {
    static let like = "ACTION_LIKE"
    static let dislike = "ACTION_DISLIKE"
    static let unfoollow = "ACTION_UNFOLLOW"
    static let setting = "ACTION_SETTING"
    private init() { }
}

struct CategoryIdentifier {
    static let imagePosting = "CATEGORY_IMAGE_POSTING"
    private init() { }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func setupCategory() {
        let likeAction = UNNotificationAction(identifier: ActionIdentifier.like,
                                              title: "Like",
                                              options: [])
        let dislikeAction = UNNotificationAction(identifier: ActionIdentifier.dislike,
                                                 title: "Dislike",
                                                 options: [])
        let unfollowAction = UNNotificationAction(identifier: ActionIdentifier.unfoollow,
                                                  title: "Unfollow",
                                                  options: [.authenticationRequired, .destructive])
        let settingAction = UNNotificationAction(identifier: ActionIdentifier.setting,
                                                 title: "Setting",
                                                 options: [.foreground])
        
        var options = UNNotificationCategoryOptions.customDismissAction
        
        if #available(iOS 11.0, *) {
            options.insert(.hiddenPreviewsShowTitle)
        }
        
        let imagePostingCategory = UNNotificationCategory(identifier: CategoryIdentifier.imagePosting,
                                                          actions: [likeAction, dislikeAction, unfollowAction, settingAction],
                                                          intentIdentifiers: [],
                                                          options: options)
        UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Local Notification 권한 요청
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] (granted, error) in
                if granted {
                    UNUserNotificationCenter.current().delegate = self
                    self?.setupCategory()
                }
                
                print("granted \(granted)")
            }
        
        return true
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Foreground에서 Notification이 오면 해당 메소드가 실행 된다.
        let content = notification.request.content
        let trigger = notification.request.trigger
        
        completionHandler([UNNotificationPresentationOptions.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // 사용자가 Notification Banner를 터치하거나 NotificationCenter에서 Notification을 통해 앱을 실행하면 이 메소드가 호출 된다.
        let content = response.notification.request.content
        let trigger = response.notification.request.trigger
        
        switch response.actionIdentifier {
        case ActionIdentifier.like:
            print("Like")
        case ActionIdentifier.dislike:
            print("Dislike")
        case UNNotificationDismissActionIdentifier:
            print("Custom Dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("launch from noti")
        default:
            print("Default")
        }
        
        UserDefaults.standard.setValue(response.actionIdentifier, forKey: "usersel")
        UserDefaults.standard.synchronize()
        
        completionHandler()
    }
}


























