// ContentView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var cards: Array<CardModel> = Array<CardModel>(repeating: CardModel.example,
                                                                 count: 10)
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      /// Place our cards and timer on top of a background :
      ZStack {
         Image("background")
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
         /// Place a timer above our cards :
         VStack {
            /// Make our stack of cards partially overlap with a neat 3D effect :
            ZStack {
               ForEach(0..<cards.count) { (index: Int) in
                  CardView(card: cards[index])
                     .stacked(at: index,
                              in: cards.count)
               }
            }
         }
      }
   }
}





// MARK: - EXTENSIONS -

extension View {
   
    func stacked(at position: Int,
                 in total: Int)
    -> some View {
      
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0,
                                  height: offset * 10))
    }
}





// MARK: - PREVIEWS -

struct ContentView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      ContentView()
   }
}
