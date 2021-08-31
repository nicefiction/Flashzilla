// NotificationCenterMessages.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/how-to-be-notified-when-your-swiftui-app-moves-to-the-background

// MARK: - LIBRARIES -

import SwiftUI



struct NotificationCenterMessages: View {
   
   // MARK: COMPUTED PROPERTIES
   
   var body: some View {
      
      Text("Messages from the Notification center:")
         .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            print("Moving to the Background.")
         }
         .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            print("Moving back to the foreground!")
         }
         .onReceive(NotificationCenter.default.publisher(for: UIApplication.userDidTakeScreenshotNotification)) { _ in
            print("User took a screenshot!")
         }
      /// There are so many of these that I can’t realistically list them all here ,
      /// so instead here are two more to try out :
      /// `UIApplication.significantTimeChangeNotification` is called
      /// when the user changes their clock or when daylight savings time changes .
      /// `UIResponder.keyboardDidShowNotification` is called when the keyboard is shown .
   }
}





// MARK: - PREVIEWS -

struct NotificationCenterMessages_Previews: PreviewProvider {
   
   static var previews: some View {
      
      NotificationCenterMessages()
   }
}
