// CardView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct CardView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var isShowingTheAnswer: Bool = false
   
   
   
   // MARK: - PROPERTIES
   
   let card: CardModel
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      ZStack {
         RoundedRectangle(cornerRadius: 25.0,
                          style: .continuous)
            .fill(Color.white)
            .shadow(radius: 10)
         VStack {
            Text(card.question)
               .font(.largeTitle)
               .foregroundColor(.black)
            if isShowingTheAnswer {
               Text(card.answer)
                  .font(.title)
                  .foregroundColor(.gray)
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
      .onTapGesture {
         isShowingTheAnswer.toggle()
      }
   }
}





// MARK: - PREVIEWS -

struct CardView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      CardView(card: CardModel.example)
   }
}
