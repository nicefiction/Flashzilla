// CardModel.swift

// MARK: - LIBRARIES -

import Foundation



struct CardModel: Codable {
   
   // MARK: - STATIC PROPERTIES
   
   static var example: CardModel {
      
      CardModel(question: "Who played the 13th Doctor in Doctor Who?",
                answer: "Jodie Whittaker")
   }
   
   
   
   // MARK: - PROPERTIES
   
   let question: String
   let answer: String
}
