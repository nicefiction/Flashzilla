// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      CardView(card: CardModel.example)
   }
}





// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
