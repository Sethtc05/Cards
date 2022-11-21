import Foundation
import SwiftUI

// A helper class used for all file reading and writing operations.
// Example: Loading the card list, buying or selling cards or updating the current balance amount.

class Fetch: ObservableObject {

    // Name of files store in the applications document directory.
    private var cardsListFilename = "cards.json";
    private var userDataFileName = "userData.json"

    // All card lists and balance amount is saved as one overall 'UserData' object.
    @Published private var userData: UserData
    
    // Initialise (aka Create)
    init() {
        
        // Create a new user data object in memory for use.
        userData = UserData.Create()
        
        // Load any previously saved user data.
        loadUserData(userDataFileName)
        
        // Are my collection and store card list both blank? If so we haven't loaded
        // the cards into the application yet so do so now.
        if (userData.collection.isEmpty && userData.store.isEmpty) {
            initialseData()
        }
    }
    
    // Buy a card - This involves several operations:
    //   1. Reduce the current balance amount by the value of the bought card.
    //   2. Remove the bought card from the stores card list.
    //   3. Add the bought card to my collection.
    //   4. JSON encode the updated user data changes and write them to the user data file.
    func buy(_ card: Card) {
        userData.balance -= card.price
        userData.store = removeCard(card, userData.store)
        userData.collection = addCard(card, userData.collection)
        saveUserData(userData, userDataFileName)
    }
    
    // Sell a card - This involved several operations:
    //  1. Increase the current balance amount by the vale of the sold card.
    //  2. Remove the sold card from my collection.
    //  3. Add the sold card to the stores card list.
    //  4. JSON encode the updated user data changes and write them to the user data file.
    func sell(_ card: Card) {
        userData.balance += card.price
        userData.collection = removeCard(card, userData.collection)
        userData.store = addCard(card, userData.store)
        saveUserData(userData, userDataFileName)
    }
    
    // Adjusts the balance amount when the user has won money.
    // JSON encode the updated user data changes and write them to the user data file.
    func adjustBalance(_ amount: Double) {
        userData.balance += amount
        saveUserData(userData, userDataFileName)
    }
    
    // Add a card to a specified card list and sort the list by name ascending.
    func addCard(_ card: Card, _ list: [Card]) -> [Card] {
        var updatedList = list
        updatedList.append(card)
        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    // Remove a card from the specified card list and sort the list by name ascending.
    func removeCard(_ card: Card, _ list: [Card]) -> [Card] {
        let updatedList = list.filter(){$0 != card}
        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    // Gets the path of the applications document directory to read or write to.
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Initialise data will be called when no cards currently exist in memory or in the user data file.
    // We need to load up the overall list of available cards into the application.
    func initialseData() {
        do {
            // Find the cards data file containing a list of all available possible cards to choose from.
            guard let dataFile = Bundle.main.url(forResource: cardsListFilename, withExtension: nil)
            else {
                // Opps! it failed to read the initial card list file. I guess the application is in trouble...
                // The file may not be present. It is part of the project soooo :/ ?????
                // we want to go KABOOM! if this isn't found because thats a big problem.
                fatalError("Could not find \(cardsListFilename) in main bundle.")
            }
            
            // Success, we found the file we were looking for hooray!
            let data = try Data(contentsOf: dataFile)
            
            // Oh, but is it empty?
            if (!data.isEmpty) {
                do {
                    // Nope not empty, let try load the JSON data contained in it.
                    userData.store = try JSONDecoder().decode([Card].self, from: data)
                } catch {
                    // Umm.. the file isn't empty but what it contains might not be in JSON format.
                    fatalError("Could not parse \(cardsListFilename) \n \(error)")
                }
            }
        } catch {
            // If anything goes wrong we would like to know about it in the output window please.
            print("Could not load card list file: \(cardsListFilename)\n \(error)")
        }
    }
    
    // Load any existing user data currently saved in the applications document directory.
    func loadUserData(_ fileName: String) {
        
        // The file we are looking for.
        var destinationFilename: URL
        
        do {
            // Get me the user data file path please.
            destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // This helps to find out where the file is actually located so we can have a nosey and see whats inside it.
            print("Loading user data file: \(destinationFilename)")
            
            // Hello Mr File Manager, does this file actually exist?
            if FileManager.default.fileExists(atPath: destinationFilename.path) {
                
                // Cool, the file we are looking for is actually there so please load its contents.
                let data = try Data(contentsOf: destinationFilename)
                
                // Oh but is this file empty?
                if (!data.isEmpty) {
                                        
                    do {
                        // No Sirree! it's there. Lets try load its contents in JSON format.
                        userData = try JSONDecoder().decode(UserData.self, from: data)
                    } catch {
                        // Yeah... the file is there but I don't know what is in it...
                        fatalError("Couldn't parse \(destinationFilename) \n \(error)")
                    }
                }
            }
        } catch {
            // Something wrong man? Tell me all about it :)
            print("Could not load user data file: \(destinationFilename)\n \(error)")
        }
    }
    
    // Save any in memory user data into a file so we can read it later if the application is closed.
    func saveUserData(_ data: UserData, _ fileName: String) {
        
        var destinationFilename: URL
        
        do {
            // Get me the user data file path please.
            destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            
            // This helps to find out where the file is actually located so we can have a nosey and see whats inside it.
            print("Saving user data file: \(destinationFilename)")
            
            // Create or write to an existing file using JSON format.
            let data = try JSONEncoder().encode(data)
            
            // Write to the file please.
            try data.write(to: destinationFilename)
            
        } catch {
            // Ah... well i'm be darned. What happened?
            fatalError("Could not save user data file: \(destinationFilename)\n \(error)")
        }
    }
    
    func getCollection() -> [Card] {
        return userData.collection.sort()
    }
    
    func getStore() -> [Card] {
        
        var storeCards: [Card] = [];
        
        for i in userData.store.indices {
            
            if (userData.store[i].name == "Mystrey Box") {
                var mystreyBox = userData.store[i];
                mystreyBox.price = Double(userData.store.getTotal()) / Double(userData.store.count)
                storeCards.append(mystreyBox);
            }
            else {
                storeCards.append(userData.store[i])
            }
        }
        
        return storeCards.sort()
    }
    
    func getBalance() -> Double {
        return userData.balance
    }
}
