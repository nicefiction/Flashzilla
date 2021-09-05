// ContentView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/moving-views-with-draggesture-and-offset
// https://www.hackingwithswift.com/books/ios-swiftui/counting-down-with-a-timer

// MARK: - LIBRARIES -

import SwiftUI



struct ContentView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
   @Environment(\.accessibilityEnabled) var accessibilityEnabled
   //   @State private var cards: Array<CardModel> = Array<CardModel>(repeating: CardModel.example,
   //                                                                 count: 10)
   @State private var cards: Array<CardModel> = Array<CardModel>()
   @State private var remainingTime = 100
   @State private var timerIsActive: Bool = true
   @State private var isShowingEditScreen: Bool = false
   
   
   
   // MARK: - PROPERTIES
   
   let timer = Timer.publish(every: 1,
                             on: .main,
                             in: RunLoop.Mode.common).autoconnect()
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      /// Place our cards and timer on top of a background :
      ZStack {
         /// Use a `decorative` image
         /// so it won’t be read out as part of the accessibility layout :.
         Image(decorative: "background")
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
                  /// Only the last card – the one on top – can be dragged around :
                  .allowsHitTesting(index == cards.count - 1)
                  /// Every card that’s at an index less than the top card
                  /// should be hidden from the accessibility system
                  /// because there is really nothing useful it can do with the card :
                  .accessibility(hidden: index < cards.count - 1)
               }
               if accessibilityDifferentiateWithoutColor || accessibilityEnabled {
                  VStack {
                     Spacer()
//                     HStack {
//                        Image(systemName: "xmark.circle")
//                           .padding()
//                           .background(Color.black.opacity(0.70))
//                           .clipShape(Circle())
//                        Spacer()
//                        Image(systemName: "checkmark.circle")
//                           .padding()
//                           .background(Color.black.opacity(0.70))
//                           .clipShape(Circle())
//                     }
                     HStack {
                        Button(action: {
                           withAnimation {
                              self.removeCard(at: self.cards.count - 1)
                           }
                        }) {
                           Image(systemName: "xmark.circle")
                              .padding()
                              .background(Color.black.opacity(0.7))
                              .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        Button(action: {
                           isShowingEditScreen.toggle()
                        }, label: {
                           Image(systemName: "plus.circle")
                              .font(.largeTitle)
                              .foregroundColor(.white)
                              .padding()
                              .background(Color.blue.opacity(0.7))
                              .clipShape(Circle())
                           
                        })
                        Spacer()
                        Button(action: {
                           withAnimation {
                              self.removeCard(at: self.cards.count - 1)
                           }
                        }) {
                           Image(systemName: "checkmark.circle")
                              .padding()
                              .background(Color.black.opacity(0.7))
                              .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
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
      .sheet(isPresented: $isShowingEditScreen,
             onDismiss: resetGame) {
         EditCardsView()
      }
      .onAppear(perform: resetGame)
   }
   
   
   
   // MARK: - METHODS
   
   func removeCard(at index: Int) {
      
      /// Because those buttons remain onscreen even when the last card has been removed ,
      /// we need to add a `guard` check to the start of `removeCard(at:)`
      /// to make sure we don’t try to remove a card that doesn’t exist :
      guard index >= 0
      else { return }
      
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
      loadData()
   }
   
   
   func loadData() {
      
      if let data = UserDefaults.standard.data(forKey: "Cards") {
         if let decoded = try? JSONDecoder().decode([CardModel].self,
                                                    from: data) {
            self.cards = decoded
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
         .previewDevice("iPad Pro (9.7-inch)")
   }
}
