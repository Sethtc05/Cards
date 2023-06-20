import SwiftUI

struct Home: View {
  
    @State private var selection = 0;
    
    @ObservedObject public var fetch = CardsApp.fetch;
    @ObservedObject var play = CardsApp.play;
    
    @State private var isShowingAlert: Bool = true;
    @State private var alertInput: String = "";
    @State private var currentUsername: String = "";
    @State private var currentPassword: String = "";
    @State private var incorrectLogin: Bool = false;

    // The main outer view of the application.
    // Three tabs: My Collection, Store and Play.
    // Two lists of cards and a spinning wheel game to earn more money.
    var body: some View {
        
        if (!fetch.isUserLoggedIn())
        {
            ZStack {
                
                Color.black
                    .opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack (spacing: 0) {
                    
                    Image(systemName: "figure.wave.circle")
                        .resizable()
                        .frame(width: 140.0, height: 140.0)
                        .foregroundColor(Color.blue)
                                        
                    Spacer()
                        .frame(maxHeight: 10)
                    
                    Text("Hello")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)
                    
                    Spacer()
                        .frame(maxHeight: 30)
                    
                    Text("Please enter your login details below:")
                        .font(.system(size: 12))
                    
                    TextField("Username", text: $currentUsername)
                        .padding(10)
                        .foregroundColor(Color.gray)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Password", text: $currentPassword)
                        .padding(10)
                        .foregroundColor(Color.gray)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if (incorrectLogin) {

                        Label("Incorrect login details. Please try again.", systemImage: "exclamationmark.triangle")
                            .foregroundColor(Color.red)
                            .font(.system(size: 12))
                    }
                    
                    Spacer()
                        .frame(maxHeight: 60)
  
                    Button {
                        withAnimation {
                            
                            if (fetch.login(username: currentUsername, password: currentPassword)) {
                                currentUsername = "";
                                currentPassword = "";
                                incorrectLogin = false;
                                return;
                            }
                            
                            incorrectLogin = true;
                        }
                    }
                    label: {
                        Label("Sign In", systemImage: "applelogo")
                            .foregroundColor(Color.white)
                            .font(.system(size: 18))
                            .frame(width: 120, height: 40)
                    }
                }
                .padding(28)
                .buttonStyle(.borderedProminent)
            }
        }
        else
        {
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
            }
        }
    }
}
