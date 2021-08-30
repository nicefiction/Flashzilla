// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/making-vibrations-with-uinotificationfeedbackgenerator-and-core-haptics

// MARK: - LIBRARIES -

import SwiftUI
import CoreHaptics



struct AdvancedHapticsExperiment: View {
   
   // MARK: - PROPERTY WRAPPERS
   
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

       do {
           self.engine = try CHHapticEngine()
           try engine?.start()
       } catch {
           print("There was an error creating the engine: \(error.localizedDescription)")
       }
   }
   
   
   func complexSuccess() {
      
       /// Make sure that the device supports haptics :
       guard CHHapticEngine.capabilitiesForHardware().supportsHaptics
       else { return }
      
       var events = [CHHapticEvent]()

       /// Create several taps of increasing then decreasing intensity and sharpness :
      for i in stride(from: 0,
                      to: 1,
                      by: 0.1) {
          let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                 value: Float(i))
          let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                 value: Float(i))
          let event = CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [intensity, sharpness],
                                    relativeTime: i)
          events.append(event)
      }

      for i in stride(from: 0,
                      to: 1,
                      by: 0.1) {
          let intensity = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                 value: Float(1 - i))
          let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                 value: Float(1 - i))
          let event = CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [intensity, sharpness],
                                    relativeTime: 1 + i)
          events.append(event)
      }

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

struct AdvancedHapticsExperiment_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedHapticsExperiment()
    }
}
