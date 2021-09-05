// EditCardsView.swift

// MARK: - LIBRARIES -

import SwiftUI



struct EditCardsView: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @Environment(\.presentationMode) var presentationMode
   @State private var cards = [CardModel]()
   @State private var newQuestion = ""
   @State private var newAnswer = ""
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      NavigationView {
         List {
            Section(header: Text("Add new card")) {
               TextField("Question",
                         text: $newQuestion)
               TextField("Answer",
                         text: $newAnswer)
               Button("Add card",
                      action: addCard)
            }
            
            Section {
               ForEach(0..<cards.count, id: \.self) { index in
                  VStack(alignment: .leading) {
                     Text(self.cards[index].question)
                        .font(.headline)
                     Text(self.cards[index].answer)
                        .foregroundColor(.secondary)
                  }
               }
               .onDelete(perform: removeCards)
            }
         }
         .navigationBarTitle("Edit Cards")
         .navigationBarItems(trailing: Button("Done",
                                              action: dismiss))
         .listStyle(GroupedListStyle())
         .navigationViewStyle(StackNavigationViewStyle()) // OLIVIER : The Landscape View works without this modifier as well .
         .onAppear(perform: loadData)
      }
   }
   
   
   
   // MARK: - METHODS
   
   func dismiss() {
      
      presentationMode.wrappedValue.dismiss()
   }
   
   
   func loadData() {
      
      if let data = UserDefaults.standard.data(forKey: "Cards") {
         if let decoded = try? JSONDecoder().decode([CardModel].self,
                                                    from: data) {
            self.cards = decoded
         }
      }
   }
   
   
   func saveData() {
      
      if let data = try? JSONEncoder().encode(cards) {
         UserDefaults.standard.set(data,
                                   forKey: "Cards")
      }
   }
   
   
   func addCard() {
      
      let trimmedQuestion = newQuestion.trimmingCharacters(in: .whitespaces)
      let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
      
      guard trimmedQuestion.isEmpty == false && trimmedAnswer.isEmpty == false
      else { return }
      
      let card = CardModel(question: trimmedQuestion,
                           answer: trimmedAnswer)
      cards.insert(card,
                   at: 0)
      saveData()
   }
   
   
   func removeCards(at offsets: IndexSet) {
      
      cards.remove(atOffsets: offsets)
      saveData()
   }
}





// MARK: - PREVIEWS -

struct EditCardsView_Previews: PreviewProvider {
   
   static var previews: some View {
      
      EditCardsView()
   }
}
