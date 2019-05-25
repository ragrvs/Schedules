//
//  AppDelegate.swift
//  Schedules
//
//  Created by Richard Zhunio on 4/11/19.
//  Copyright © 2019 Richard Zhunio. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Google Cloud Messaging key
    let gcmMessageIDKey = "gcm.message_id"

    /// Configures firebase, remote notifications, and cloud messaging for notifications
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // To receive registration tokens
        let messsaging = Messaging.messaging()
        messsaging.delegate = self

        requestNotificationAuthorization(application)
        
        return true
    }
    
    /// Request notification authorization
    private func requestNotificationAuthorization(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
    }
}

// MARK: - Notification

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    /// Receives notifications when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // Retrieve the userinfo where the notification is
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            NSLog("Message ID: \(messageID)")
        }
        
        // Print full message.
        NSLog("userInfo: \(userInfo)")
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            NSLog("Message ID: \(messageID)")
        }
        
        // Print full message.
        NSLog("userInfo: \(userInfo)")
    }
    
    /// Receives notification when the app is in the background
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            NSLog("Message ID: \(messageID)")
        }
        
        // Print full message.
        NSLog("userInfo: \(userInfo)")
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
  
}

// MARK: - Messaging

extension AppDelegate: MessagingDelegate {

    /// Receives firebase registration token needed to work with Apple Push Notifications (APNs)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("Firebase registration token: \(fcmToken)")
        
        // Post notifications
        NotificationCenter.default
            .post(name: .init(rawValue: "FCMToken"), object: nil, userInfo: ["token": fcmToken])
    }
}
