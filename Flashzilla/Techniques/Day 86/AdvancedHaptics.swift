// AdvancedHaptics.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics

// MARK: - LIBRARIES -

import SwiftUI
import CoreHaptics // STEP 1



struct AdvancedHaptics: View {
   
   // MARK: - PROPERTY WRAPPERS
   /// `STEP 2 `Create an instance of `CHHapticEngine` as a property
   /// – this is the actual object that is responsible for creating vibrations ,
   /// so we need to create it up front before we want haptic effects :
   @State private var engine: CHHapticEngine?
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      Text("One intense , sharp tap.")
         .onAppear(perform: prepareHaptics)
         .onTapGesture(perform: complexSuccess)
   }
   
   
   
   // MARK: - METHODS
   
   func prepareHaptics() {
      
       guard CHHapticEngine.capabilitiesForHardware().supportsHaptics
       else { return }

      /// We are going to create an instance of `CHHapticEngine`
      /// as soon as our main view appears .
      /// When creating the engine
      /// you can attach handlers to help resume activity if it gets stopped ,
      /// such as when the app moves to the background ,
      /// but here we are going to keep it simple :
      /// if the current device supports haptics
      /// we will start the engine , and print an error if it fails :
       do {
           self.engine = try CHHapticEngine()
           try engine?.start()
       } catch {
           print("There was an error creating the engine: \(error.localizedDescription)")
       }
   }
   
   
   /// We can configure parameters that control how strong the haptic should be (`.hapticIntensity`)
   /// and how _sharp_ it is (`.hapticSharpness`) ,
   /// then put those into a haptic `event` with a `relativeTime` offset :
   func complexSuccess() {
      
       /// Make sure that the device supports haptics :
       guard CHHapticEngine.capabilitiesForHardware().supportsHaptics
       else { return }
      
       var events = [CHHapticEvent]()

       /// Create one intense , sharp tap :
       let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                              value: 1)
       let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                              value: 1)
       let event = CHHapticEvent(eventType: .hapticTransient,
                                 parameters: [intensity, sharpness],
                                 relativeTime: 0)
       events.append(event)

       /// Convert those events into a pattern and play it immediately :
       do {
           let pattern = try CHHapticPattern(events: events,
                                             parameters: [])
           let player = try engine?.makePlayer(with: pattern)
           try player?.start(atTime: 0)
       } catch {
           print("Failed to play pattern: \(error.localizedDescription).")
       }
   }
}




// MARK: - PREVIEWS -

struct AdvancedHaptics_Previews: PreviewProvider {
   
   static var previews: some View {
      
      AdvancedHaptics()
   }
}
