---
title: Background Tasks
excerpt: iOS
---

https://developer.apple.com/documentation/backgroundtasks/choosing_background_strategies_for_your_app

## Factors affecting runtime

1. Critically low batter
2. Low Power Mode
3. App usage (AI learns about app usage)
4. App switcher (if user explicitly kills specific app)
5. Background App Refresh switch (there's notification to know when switch is changed)
6. System budgets (every app has a system defined budget)
7. Rate limiting

## Background App Refresh tasks

## Background pushes

Background pushes silently wakes up the app without displaying any alert or playing the sound. 

Once the system delivers the remote notification with application`(_:didReceiveRemoteNotification:fetchCompletionHandler:)`, the app has up to 30 seconds to complete its work. One your app performs the work, call the passed completion handler as soon as possible to conserve power.

## URLSession background transfers

```swift

private lazy var urlSession: URLSession = {
    let config = URLSessionConfiguration.background(withIdentifier: "MySession")
    config.isDiscretionary = true // System waits for optimal conditions to perform the transfer
    config.sessionSendsLaunchEvents = true // System wakes up the app when the ask completes and the app is in the background
    return URLSession(configuration: config, delegate: self, delegateQueue: nil)
}()

// System calls this method when the download finishes
// Store the completion handler to call later
func application(_ application: UIApplication,
                 handleEventsForBackgroundURLSession identifier: String,
                 completionHandler: @escaping () -> Void) {
        backgroundCompletionHandler = completionHandler
}

func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let backgroundCompletionHandler =
            appDelegate.backgroundCompletionHandler else {
                return
        }
        backgroundCompletionHandler()
    }
}
```

## Notify the user about a background task

If your app needs to perform a task in the background and show a notification to the user, use a Notification Service Extension. For example, an email app might need to notify a user after downloading a new email. Subclass `UNNotificationServiceExtension` and bundle the system extension with your app. Upon receiving a push notification, your service extension wakes up and obtains background runtime through didReceive(_:withContentHandler:).
When your extension completes its work, it must call the content handler with the content you want to deliver to the user. Your extension has a limited amount of time to modify the content and execute the contentHandler block.

## Background processing tasks

To preserve battery life and performance, you can schedule backgrounds tasks for periods of low activity, such as overnight when the device charges. Use this approach when your app manages heavy workloads, such as training machine learning models or performing database maintenance.
Schedule these types of background tasks using `BGProcessingTask`, and the system decides the best time to launch your background task.