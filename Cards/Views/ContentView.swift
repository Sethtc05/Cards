import SwiftUI

struct ContentView: View {
  
    @State private var selection = 0
    
    @ObservedObject var fetch = CardsApp.fetch
    @ObservedObject var play = CardsApp.play
    
    @State private var isShowingAlert = true
    @State private var alertInput = ""

    // The main outer view of the application.
    // Three tabs: My Collection, Store and Play.
    // Two lists of cards and a spinning wheel game to earn more money.
    var body: some View {
        
        VStack (spacing: 0) {
            
            TabView(selection: $selection) {
                
                // Collection tab
                CardList(
                    fetch: fetch,
                    cards: fetch.getCollection(),
                    listType: ListType.collection,
                    title: alertInput != "" ? alertInput + "'s Collection" : "Collection"
                )
                .tabItem {
                    VStack {
                        selection == 0 ? Image("collection_tab_selected") : Image("collection_tab")
                        Text("Collection")
                    }
                }.tag(0)
                
                // Store tab
                CardList(
                    fetch: fetch,
                    cards: fetch.getStore(),
                    listType: ListType.store,
                    title: "Store"
                )
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
            
        }.textFieldAlert(
            isShowing: $isShowingAlert,
            text: $alertInput,
            title: "Hello, please enter your name:"
        )
    }
}
