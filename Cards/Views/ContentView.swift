import SwiftUI

struct ContentView: View {
  
    @State private var selection = 0
    
    @ObservedObject var fetch = CardsApp.fetch
    @ObservedObject var play = CardsApp.play

    var body: some View {
        
         TabView(selection: $selection) {
            
            // Collection tab
            CardList(fetch: fetch, cards: fetch.userData.collection, listType: ListType.collection)
                .tabItem {
                    VStack {
                        selection == 0 ? Image("collection_tab_selected") : Image("collection_tab")
                        Text("Collection")
                    }
                }.tag(0)
            
            // Store tab
            CardList(fetch: fetch, cards: fetch.userData.store, listType: ListType.store)
                .tabItem {
                    VStack {
                        selection == 1 ? Image("store_tab_selected") : Image("store_tab")
                        Text("Store")
                    }
                }.tag(1)
            
            // Play tab
            PlayView(play: play)
                .tabItem {
                    VStack {
                        selection == 2 ? Image("play_tab_selected") : Image("play_tab")
                        Text("Play")
                    }
                }.tag(2)
        }
    }
}
