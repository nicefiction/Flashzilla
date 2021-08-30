// MultipleGestures.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui

// MARK: - LIBRARIES -

import SwiftUI



struct MultipleGestures: View {
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      // DefaultView()
      SimultaneousView()
   }
}



// MARK: - DEFAULT VIEW -
/// If not specified ,
/// the child VIew gets priority :

struct DefaultView: View {
   
   var body: some View {
      
      VStack {
         Text("Child Gesture")
            .onTapGesture {
               print("Text tapped.")
            }
      }
      .onTapGesture {
         print("VStack tapped.")
      }
   }
}



// MARK: - SIMULTANEOUS VIEW -
/// Use the `simultaneousGesture()` modifier to tell SwiftUI
/// you want both the parent and child gestures to trigger at the same time :

struct SimultaneousView: View {
   
   var body: some View {
      
      VStack {
         Text("Simultaneous Gesture")
            .onTapGesture {
               print("Text tapped.")
            }
      }
      .simultaneousGesture (
         TapGesture()
            .onEnded {
               print("VStack tapped.")
            }
      )
   }
}
/*
 var body: some View {
        VStack {
            Text("Hello, World!")
                .onTapGesture {
                    print("Text tapped")
                }
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    print("VStack tapped")
                }
        )
    }
 */

// MARK: - PREVIEWS -

struct MultipleGestures_Previews: PreviewProvider {
   
   static var previews: some View {
      
      MultipleGestures()
   }
}
