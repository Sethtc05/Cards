import SwiftUI

@main
struct CardsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate    
    @Environment(\.scenePhase) var scenePhase

    init() {
        // Application Load
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    print("Incoming URL: \(url)")
                })
        }
        .onChange(of: scenePhase) { (newScreenPhase) in
            switch (newScreenPhase) {
                case .background:
                    print("App State:  Background")
                case .inactive:
                    print("App State: Inactive")
                case .active:
                    print("App State: Active")
                @unknown default:
                    print("App State: Unknown")
            }
        }
    }
}
