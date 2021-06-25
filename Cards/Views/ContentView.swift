import SwiftUI

struct ContentView: View {
  
    @ObservedObject var fetch = Fetch()
    @State private var selection = 0
    
    var body: some View {
        
         TabView(selection: $selection) {
            
            CardList(cards: fetch.collectionCards, listType: ListType.collection, fetch: fetch)
                .tabItem {
                    VStack {
                        selection == 1 ? Image("collection_tab") : Image("collection_tab_selected")
                        Text("Collection")
                    }
                }
                .tag(0)
            
            CardList(cards: fetch.storeCards, listType: ListType.store, fetch: fetch)
                .tabItem {
                    VStack {
                        selection == 0 ? Image("store_tab") : Image("store_tab_selected")
                        Text("Store")
                    }
                }
                .tag(1)
        }
    }
}
