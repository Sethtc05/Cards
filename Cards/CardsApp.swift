import SwiftUI

// The big main application class - This is where we start the journey off.

@main
struct CardsApp: App {
      
    static var fetch = Fetch()
    static var play = Play()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
        }
    }
}
