// GestureSequences.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/how-to-use-gestures-in-swiftui
/// SwiftUI lets us create gesture sequences ,
/// where one gesture will only become active if another gesture has first succeeded .
/// This takes a little more thinking because the gestures need to be able to reference each other ,
/// so you can’t just attach them directly to a view .

// MARK: - LIBRARIES -

import SwiftUI



struct GestureSequences: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   /// How far the circle is being dragged :
   @State private var dragOffset: CGSize = CGSize.zero
   /// Is the circle currently being dragged ?
   @State private var isBeingDragged: Bool = false
   
   /*
    let dragGesture = DragGesture()
           .onChanged { value in self.offset = value.translation }
           .onEnded { _ in
               withAnimation {
                   self.offset = .zero
                   self.isDragging = false
               }
           }

       // a long press gesture that enables isDragging
       let pressGesture = LongPressGesture()
           .onEnded { value in
               withAnimation {
                   self.isDragging = true
               }
           }

       // a combined gesture that forces the user to long press then drag
       let combined = pressGesture.sequenced(before: dragGesture)
    */
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      /// A long press gesture that enables `isBeingDragged` :
      let pressGesture = LongPressGesture()
         .onEnded { value in
            withAnimation {
               self.isBeingDragged = true
            }
         }
      
      
      /// A drag gesture that updates `dragOffset` and `isBeingDragged` as it moves around :
      let dragGesture = DragGesture()
         .onChanged { value in
            self.dragOffset = value.translation
         }
         .onEnded { _ in
            withAnimation {
               self.dragOffset = .zero
               self.isBeingDragged = false
            }
         }
      
      
      /// A combined gesture that forces the user to long press then drag :
      let combined = pressGesture.sequenced(before: dragGesture)
      
      /// a 64x64 circle that scales up when it is dragged ,
      /// sets its offset to whatever we had back from the drag gesture ,
      /// and uses our combined gesture :
      return Circle()
         .fill(Color.red)
         .frame(width: 64, height: 64)
         .scaleEffect(isBeingDragged ? 1.5 : 1)
         .offset(dragOffset)
         .gesture(combined)
   }
}




// MARK: - PREVIEWS -

struct GestureSequences_Previews: PreviewProvider {
   
   static var previews: some View {
      
      GestureSequences()
   }
}
