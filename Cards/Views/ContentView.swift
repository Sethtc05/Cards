import SwiftUI

struct ContentView: View {
  
    @State private var selection = 0
    
    @ObservedObject var fetch = CardsApp.fetch
    @ObservedObject var play = CardsApp.play

    var body: some View {
        
         TabView(selection: $selection) {
            
            // Collection tab
            CardList(fetch: fetch, cards: fetch.collectionCards, listType: ListType.collection)
                .tabItem {
                    VStack {
                        selection == 1 ? Image("collection_tab") : Image("collection_tab_selected")
                        Text("Collection")
                    }
                }.tag(0)
            
            // Store tab
            CardList(fetch: fetch, cards: fetch.storeCards, listType: ListType.store)
                .tabItem {
                    VStack {
                        selection == 0 ? Image("store_tab") : Image("store_tab_selected")
                        Text("Store")
                    }
                }.tag(1)
            
            // Play tab
            PlayView(play: play)
                .tabItem {
                    VStack {
                        selection == 2 ? Image("store_tab") : Image("store_tab_selected")
                        Text("Play")
                    }
                }.tag(2)
        }
    }
}
