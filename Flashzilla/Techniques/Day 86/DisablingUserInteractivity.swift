// DisablingUserInteractivity.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/disabling-user-interactivity-with-allowshittesting
/// SwiftUI lets us control user interactivity in two useful ways ,
/// `1`  The first of which is the `allowsHitTesting()` modifier .
/// When this is attached to a view with its parameter set to `false`,
/// the view isn’t even considered tappable .
/// That doesn’t mean it’s inert , though , just that it doesn’t catch any taps
/// – things behind the view will get tapped instead .
/// `2` The other useful way of controlling user interactivity is with the `contentShape()` modifier ,
/// which lets us specify the tappable shape for something .
/// By default the tappable shape for a circle is a circle of the same size ,
/// but you can specify a different shape instead .


// MARK: - LIBRARIES -

import SwiftUI



struct DisablingUserInteractivity: View {
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      ZStack {
         Rectangle()
            .foregroundColor(.yellow)
            .frame(width: 300,
                   height: 300)
            .onTapGesture {
               print("Rectangle")
            }
         Circle()
            .foregroundColor(.blue)
            .frame(width: 300)
            .contentShape(Rectangle())
            .onTapGesture {
               print("Circle")
            }
            /// Tapping the circle will always print _Rectangle_ ,
            /// because the circle will refuses to respond to taps :
            // .allowsHitTesting(false)
      }
   }
}





// MARK: - PREVIEWS -

struct DisablingUserInteractivity_Previews: PreviewProvider {
   
   static var previews: some View {
      
      DisablingUserInteractivity()
   }
}
