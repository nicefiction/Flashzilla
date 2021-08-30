// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/disabling-user-interactivity-with-allowshittesting

// MARK: - LIBRARIES -

import SwiftUI



struct TappableStackSpacer: View {
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      VStack {
         Text("Hello")
         Spacer()
            .frame(height: 100)
         Text("World")
      }
      /// If we use `contentShape(Rectangle())` on the `VStack`
      /// then the whole area for the stack becomes tappable , including the spacer :
      .contentShape(Rectangle())
      .onTapGesture {
         print("VStack tapped.")
      }
   }
}





// MARK: - PREVIEWS -

struct TappableStackSpacer_Previews: PreviewProvider {
   
   static var previews: some View {
      
      TappableStackSpacer()
   }
}
