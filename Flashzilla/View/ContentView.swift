// ContentView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset
// https://www.hackingwithswift.com/books/ios-swiftui/counting-down-with-a-timer

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
   @State private var cards: Array<CardModel> = Array<CardModel>(repeating: CardModel.example,
                                                                 count: 10)
   @State private var remainingTime = 100
   @State private var timerIsActive: Bool = true
   
   
   
   // MARK: - PROPERTIES
   
   let timer = Timer.publish(every: 1,
                             on: .main,
                             in: RunLoop.Mode.common).autoconnect()
   
   
   
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
            Text("Remaining cards : \(cards.count)")
               .font(.headline)
               .foregroundColor(.white)
            Text("Time: \(remainingTime)")
               .font(.largeTitle)
               .foregroundColor(.white)
               .padding(.horizontal, 20)
               .padding(.vertical, 5)
               .background(
                  Capsule()
                     .fill(Color.black)
                     .opacity(0.65))
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
               if accessibilityDifferentiateWithoutColor {
                  VStack {
                     Spacer()
                     HStack {
                        Image(systemName: "xmark.circle")
                           .padding()
                           .background(Color.black.opacity(0.70))
                           .clipShape(Circle())
                        Spacer()
                        Image(systemName: "checkmark.circle")
                           .padding()
                           .background(Color.black.opacity(0.70))
                           .clipShape(Circle())
                     }
                     .font(.largeTitle)
                     .foregroundColor(.white)
                     .padding()
                  }
               }
            }
            /// Disables swiping on any card when the time runs out :
            .allowsHitTesting(remainingTime > 0)
            if cards.isEmpty {
               Button("Start New Game",
                      action: resetGame)
                  .padding()
                  .background(Color.white)
                  .foregroundColor(.black)
                  .clipShape(Capsule())
            }
         }
         .padding()
      }
      .onReceive(timer) { _ in
         guard timerIsActive
         else { return }
         
         if remainingTime > 0 {
            remainingTime -= 1
         }
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
         self.timerIsActive = false
      }
      .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
         if cards.isEmpty == false {
            self.timerIsActive = true
         }
      }
   }
   
   
   
   // MARK: - METHODS
   
   func removeCard(at index: Int) {
      
      cards.remove(at: index)
      if cards.isEmpty {
         timerIsActive = false
      }
   }
   
   
   func resetGame() {
      
      cards = Array<CardModel>(repeating: CardModel.example,
                               count: 10)
      remainingTime = 100
      timerIsActive = true
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
