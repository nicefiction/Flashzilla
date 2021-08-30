// AdvancedGestures.swift
// MARK:
// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui

// MARK: - GESTURES -

import SwiftUI



struct AdvancedGestures: View {
   
   // MARK: PROPERTY WRAPPERS
   var body: some View {
      
      Group {
         // MagnificationGestureView()
         RotationGestureView()
      }
      .font(.title)
   }
}




// MARK: - MAGNIFICATION GETSURE VIEW -

struct MagnificationGestureView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var startScaleAmount: CGFloat = 0.00
   @State private var endScaleAmount: CGFloat = 1.00
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      return Text("Magnify")
         .scaleEffect(startScaleAmount + endScaleAmount)
         .gesture(
            MagnificationGesture()
               .onChanged({ (amount: CGFloat) in
                  startScaleAmount = amount - 1
               })
               .onEnded({ (amount: CGFloat) in
                  endScaleAmount += startScaleAmount
                  startScaleAmount = 0
               })
         )
   }
}



// MARK: - ROTATION GETSURE VIEW -

struct RotationGestureView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var startAngleAmount: Angle = Angle.degrees(0.00)
   @State private var endAngleAmount: Angle = Angle.degrees(0.00)
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      return Text("Rotate")
         .rotationEffect(startAngleAmount + endAngleAmount)
         .gesture(
            RotationGesture()
               .onChanged { (angle: Angle) in
                  startAngleAmount = angle
               }
               .onEnded { (angle: Angle) in
                  endAngleAmount += startAngleAmount
                  startAngleAmount = Angle.degrees(0.00)
               }
         )
   }
}





// MARK: - PREVIEWS -

struct AdvancedGestures_Previews: PreviewProvider {
   
   static var previews: some View {
      
      AdvancedGestures()
   }
}
