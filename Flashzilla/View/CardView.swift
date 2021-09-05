// CardView.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/making-iphones-vibrate-with-uinotificationfeedbackgenerator
// https://www.hackingwithswift.com/books/ios-swiftui/fixing-the-bugs

// MARK: - LIBRARIES -

import SwiftUI



struct CardView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
   /// SwiftUI doesn’t have an environment property that tells us when VoiceOver is running ,
   /// but instead has a general property called `\.accessibilityEnabled`.
   /// This isn’t triggered when things like Differentiate Without Color , Reduce Motion , or Reduce Transparency are enabled ,
   /// and it’s the closest option SwiftUI gives us to “VoiceOver Running” :
   @Environment(\.accessibilityEnabled) var accessibilityEnabled
   @State private var isShowingTheAnswer: Bool = false
   @State private var dragAmount: CGSize = CGSize.zero // offset (PAUL HUDSON)
   @State private var uiNotificationFeedbackGenerator = UINotificationFeedbackGenerator()
   
   
   
   // MARK: - PROPERTIES
   
   let card: CardModel
   /// We don’t want `CardView` to call up to `ContentView` and manipulate its data directly ,
   /// because that causes spaghetti code . Instead ,
   /// a better idea is to store a closure parameter inside `CardView`
   /// that can be filled with whatever code we want later on
   /// – it means we have the flexibility to get a callback in `ContentView`
   /// without explicitly tying the two views together .
   var removal: (() -> Void)? = nil
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var cardFeedbackColor: some View {
      
      return RoundedRectangle(cornerRadius: 25.0,
                              style: .continuous)
         .fill(dragAmount.width > 0 ? Color.green : Color.red)
   }
   
   
   var cardDefaultColor: Color {
      
      return Color
         .white
         .opacity(1 - Double(abs(dragAmount.width / 50)))
   }
   
   
   var body: some View {
      
      return ZStack {
         RoundedRectangle(cornerRadius: 25.0,
                          style: .continuous)
            .fill(accessibilityDifferentiateWithoutColor ? Color.white : cardDefaultColor)
            .background(accessibilityDifferentiateWithoutColor ? nil : cardFeedbackColor)
            .shadow(radius: 10)
         VStack {
            if accessibilityEnabled {
               Text(isShowingTheAnswer ? card.answer : card.question)
                  .font(.largeTitle)
                  .foregroundColor(.black)
            } else {
               Text(card.question)
                  .font(.largeTitle)
                  .foregroundColor(.black)
               if isShowingTheAnswer {
                  Text(card.answer)
                     .font(.title)
                     .foregroundColor(.gray)
               }
            }
         }
         .padding(20)
         .multilineTextAlignment(.center)
      }
      /// `TIP`: A width of 450 is no accident :
      /// the smallest iPhones have a landscape width of 480 points ,
      /// so this means our card will be fully visible on all devices :.
      .frame(width: 450,
             height: 250)
      /// When it comes to moving and rotating ,
      /// this means if we want a view to slide directly to true west (regardless of its rotation) while also rotating it ,
      /// we need to put the rotation first then the offset .
      /// `Offset.width` contains how far the user has dragged our card :
      .rotationEffect(Angle.degrees(Double(dragAmount.width / 5)))
      /// Next , we are going to apply our movement ,
      /// so the card slides relative to the horizontal drag amount . Again ,
      /// we are not going to use the original value of `offset.width`
      /// because it would require the user to drag a long way to get any meaningful results ,
      /// so instead we are going to multiply it by `5`
      /// so the cards can be swiped away with small gestures :
      .offset(x: dragAmount.width * 5,
              y: 0)
      /// While we’re here , I want to add one more modifier based on the drag gesture .
      /// We are going to make the card fade out as it is dragged further away .
//      .opacity(2 - Double(abs(dragAmount.width / 50)))
      /// We’re going to take 1/50th of the drag amount , so the card doesn’t fade out too quickly .
      /// We don’t care whether they have moved to the left (negative numbers) or to the right (positive numbers) ,
      /// so we’ll put our value through the `abs()` function .
      /// If this is given a positive number
      /// it returns the same number ,
      /// but if it’s given a negative number
      /// it removes the negative sign
      /// and returns the same value as a positive number .
      /// We then use this result to subtract from `2` .
      /// The use of `2` there is intentional ,
      /// because it allows the card to stay opaque while being dragged just a little .
      /// So , if the user hasn’t dragged at all the opacity is `2.0`,
      /// which is identical to the opacity being `1`.
      /// If they drag it `50` points left or right , we divide that by `50` to get `1` ,
      /// and subtract that from `2` to get `1` , so the opacity is still `1` – the card is still fully opaque .
      /// But beyond `50` points we start to fade out the card , until at 100 points left or right
      /// the opacity is `0` .
      .accessibility(addTraits: .isButton)
      .gesture(
          DragGesture()
            /// Drag gestures have two useful modifiers of their own ,
            /// letting us attach functions to be triggered when the gesture has changed (called every time they move their finger) ,
            /// and when the gesture has ended (called when they lift their finger) .
            /// Both of these functions are handed the current gesture state to evaluate .
            /// In our case we’ll be reading the `translation` property to see where the user has dragged to ,
            /// and we’ll be using that to set our `dragAmount` property ,
            /// but you can also read the start location , predicted end location , and more .
            /// When it comes to the ended function ,
            /// we’ll be checking whether the user moved it more than 100 points in either direction
            /// so we can prepare to remove the card ,
            /// but if they haven’t
            /// we’ll set `dragAmount` back to `0`:
            .onChanged { gesture in
               dragAmount = gesture.translation
               /// We are going to update our drag gesture
               /// so that `prepare()` is called whenever the gesture changes .
               /// This means it could be called a hundred times before `play()` is finally called ,
               /// because it will get triggered every time the user moves their finger .
               /// It is perfectly allowable to call `prepare()` many times before calling `play()` once
               /// – `prepare()` doesn’t pause your app while the Taptic Engine warms up ,
               /// and also doesn’t have any real performance cost when the system is already prepared .
               uiNotificationFeedbackGenerator.prepare()
            }
            .onEnded { _ in
               if abs(self.dragAmount.width) > 100 {
                  if dragAmount.width > 0 {
                     uiNotificationFeedbackGenerator.notificationOccurred(.success)
                  } else {
                     uiNotificationFeedbackGenerator.notificationOccurred(.error)
                  }
                  // remove the card
                  self.removal?()
                  /// `TIP`: That question mark in there means the closure will only be called if it has been set .
               } else {
                  self.dragAmount = .zero
               }
            }
      )
      .onTapGesture {
         isShowingTheAnswer.toggle()
         
      }
      .animation(.spring())
   }
}





// MARK: - PREVIEWS -

struct CardView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      CardView(card: CardModel.example)
   }
}
