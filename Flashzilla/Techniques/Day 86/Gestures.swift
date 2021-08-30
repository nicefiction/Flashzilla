// Gestures.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui

// MARK: - LIBRARIES -

import SwiftUI




struct Gestures: View {
   
   var body: some View {
      
      VStack(spacing: 20) {
         Text("Double Tap")
            .onTapGesture(count: 2,
                          perform: {
                           print("Double tap gesture.")
                          })
         Text("Long Press 1 second")
            .onLongPressGesture(minimumDuration: 1.00,
                                perform: {
                                 print("1 second long press gesture.")
                                })
         Text("Long Press 2 seconds, with trigger.")
            .onLongPressGesture(minimumDuration: 2.00,
                                pressing: { (isInProgress: Bool) in
                                 print("Long press in progress: \(isInProgress)")
                                },
                                perform: {
                                 print("Long Press 2 seconds, with trigger.")
                                })
      }
   }
}
/*
 Text("Hello, World!")
     .onLongPressGesture(minimumDuration: 1, pressing: { inProgress in
         print("In progress: \(inProgress)!")
     }) {
         print("Long pressed!")
     }
 */




// MARK: - PREVIEWS -

struct Gestures_Previews: PreviewProvider {
   
   static var previews: some View {
      
      Gestures()
   }
}
