//AccessibilityViews.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/supporting-specific-accessibility-needs-with-swiftui
/// SwiftUI gives us a number of environment properties that describe the user’s custom accessibility settings ,
/// and it is worth taking the time to read and respect those settings .

// MARK: - LIBRARIES -

import SwiftUI



struct AccessibilityViews: View {
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      // DifferentiateWithoutColorView()
      // ReduceMotionView()
      ReduceTransparancyView()
   }
}





// MARK: - DifferentiateWithoutColorView -

struct DifferentiateWithoutColorView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor: Bool
   /// `TIP` You can test that in the simulator
   /// by going to the Settings app and choosing
   /// Accessibility > Display & Text Size > Differentiate Without Color
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      HStack {
         if accessibilityDifferentiateWithoutColor {
            Image(systemName: "checkmark.square")
         }
         Text("Succes")
      }
      .padding()
      .background(accessibilityDifferentiateWithoutColor ? Color.black : Color.green)
      .foregroundColor(.white)
      .clipShape(Capsule())
   }
}





// MARK: - ReduceMotionView -

struct ReduceMotionView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   ///  When `accessibilityReduceMotion` is enabled ,
   ///  apps should should limit the amount of animation that causes movement on screen .
   ///  For example , the iOS app switcher makes views fade in and out rather than scale up and down
   ///  With SwiftUI , this means we should restrict the use of `withAnimation()` when it involves movement .
   @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion
   @State private var scale: CGFloat = 1.0
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      return Text("Reduce Motion")
         .scaleEffect(scale)
         .onTapGesture {
//            if accessibilityReduceMotion {
//               scale *= 1.5
//            } else {
//               withAnimation {
//                  scale *= 1.5
//               }
//            }
            withOptionalAnimation {
               return scale *= 1.5
            }
            /// Using this approach you don’t need to repeat your animation code every time .
         }
   }
}



/// We can add a little wrapper function around `withAnimation()`
/// that uses UIKit’s UIAccessibility data directly ,
/// allowing us to bypass animation automatically :
func withOptionalAnimation<Result>(_ animation: Animation? = .default,
                                   _ body: () throws -> Result)
rethrows -> Result {
   /// `NOTE` The whole throws/rethrows thing is more advanced Swift ,
   /// but it is a direct copy of the function signature for `withAnimation()`
   /// so that the two can be used interchangeably .
   
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}





// MARK: - ReduceTransparancyView -


struct ReduceTransparancyView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
       return Text("Reduce Transparency")
         .padding()
         .background(accessibilityReduceTransparency ? Color.black : Color.black.opacity(0.50))
         .foregroundColor(.white)
         .clipShape(Capsule())
   }
}


// MARK: - PREVIEWS -

struct AccessibilityViews_Previews: PreviewProvider {
   
   static var previews: some View {
      
      AccessibilityViews()
   }
}
