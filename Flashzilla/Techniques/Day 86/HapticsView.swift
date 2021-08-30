// HapticsView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics

// MARK: - LIBRARIES -

import SwiftUI



struct HapticsView: View {
   
   // MARK: COMPUTED PROPERTIES
   
   var body: some View {
      
      Text("Simple Haptics!")
         .onTapGesture(perform: simpleSuccess)
   }
   
   
   
   // MARK: - METHODS
   
   func simpleSuccess() {
      
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.success)
   }
}





// MARK: - PREVIEWS -

struct HapticsView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      HapticsView()
   }
}
