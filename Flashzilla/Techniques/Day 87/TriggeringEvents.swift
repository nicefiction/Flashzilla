// TriggeringEvents.swift
// MARK: SOURCE
// https://www.hackingwithswift.com/books/ios-swiftui/triggering-events-repeatedly-using-a-timer

// MARK: LIBRARIES

import SwiftUI



struct TriggeringEvents: View {
   
   // MARK: - PROPERTY WRAPPERS
   
   @State private var counter: Int = 0
   
   
   
   // MARK: - PROPERTIES
   
   /// That does several things all at once :
   /// `1`It asks the timer to fire every `1` second .
   /// `2`It says the timer should run on the main thread .
   /// `3`It says the timer should run on the `common` `run loop ,
   /// which is the one you’ll want to use most of the time .
   /// ( Run loops lets iOS handle running code while the user is actively doing something ,
   /// such as scrolling in a list . )
   /// `4`It connects the timer immediately , which means it will start counting time .
   /// `5`It assigns the whole thing to the timer constant so that it stays alive .
   let timer = Timer.publish(every: 1,
                             tolerance: 0.5,
                             on: RunLoop.main,
                             in: RunLoop.Mode.common).autoconnect()
   /// `NOTE` if you’re OK with your timer having a little float ,
   /// you can specify some tolerance .
   /// This allows iOS to perform important energy optimization ,
   /// because it can fire the timer at any point between its scheduled fire time
   /// and its scheduled fire time plus the tolerance you specify .
   /// In practice this means the system can perform timer coalescing :
   /// it can push back your timer just a little so that it fires at the same time as one or more other timers ,
   /// which means it can keep the CPU idling more and save battery power .
   /// If you need to keep time strictly
   /// then leaving off the tolerance parameter will make your timer as accurate as possible ,
   /// but please note that even without any tolerance the Timer class is still _best effort_
   /// – the system makes no guarantee it will execute precisely.
   
   
   
   // MARK: - COMPUTED PROPERTIES
   
   var body: some View {
      
      Text("Triggering Events")
         /// That will print the time every second until the timer is finally stopped :
         .onReceive(timer, perform: { time in
            if counter == 5 {
               timer.upstream.connect().cancel()
            } else {
               print("The time is now \(time).")
            }
            counter += 1
         })
   }
}




// MARK: - PREVIEWS -

struct TriggeringEvents_Previews: PreviewProvider {
   
   static var previews: some View {
      
      TriggeringEvents()
   }
}
