// ContentView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
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
         if accessibilityDifferentiateWithoutColor {
//            VStack {
//               Spacer()
               HStack {
                  Group {
                     Image(systemName: "xmark.circle")
                     Spacer()
                     Image(systemName: "checkmark.circle")
                  }
                  .padding()
                  .background(Color.black.opacity(0.70))
                  .clipShape(Circle())
               }
               .font(.largeTitle)
               .foregroundColor(.white)
               .padding()
            }
//         }
         /// Place a timer above our cards :
         VStack {
            /// Make our stack of cards partially overlap with a neat 3D effect :
            ZStack {
               ForEach(0..<cards.count,
                       id: \.self) { (index: Int) in
                  CardView(card: cards[index]) {
                     withAnimation {
                        self.removeCard(at: index)
                     }
                  }
                  .stacked(at: index,
                           in: cards.count)
               }
            }
         }
      }
   }
   
   
   
   // MARK: - METHODS
   
   func removeCard(at index: Int) {
      
      cards.remove(at: index)
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
