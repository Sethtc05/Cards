import Foundation
import SwiftUI

class Fetch: ObservableObject {

    private var cardsListFilename = "cards.json";
    private var userDataFileName = "userData.json"
    
    @Published var userData: UserData
    
    init() {
        userData = UserData.Create()
        loadUserData(userDataFileName)
        
        if (userData.collection.isEmpty && userData.store.isEmpty) {
            initialseData()
        }
    }
    
    func buy(_ card: Card) {
        userData.balance -= card.price
        userData.store = removeCard(card, userData.store)
        userData.collection = addCard(card, userData.collection)
        saveUserData(userData, userDataFileName)
    }
    
    func sell(_ card: Card) {
        userData.balance += card.price
        userData.collection = removeCard(card, userData.collection)
        userData.store = addCard(card, userData.store)
        saveUserData(userData, userDataFileName)
    }
    
    func adjustBalance(_ amount: Double) {
        userData.balance += amount
        saveUserData(userData, userDataFileName)
    }
    
    func addCard(_ card: Card, _ list: [Card]) -> [Card] {
        var updatedList = list
        updatedList.append(card)
        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    func removeCard(_ card: Card, _ list: [Card]) -> [Card] {
        let updatedList = list.filter(){$0 != card}
        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func initialseData() {
        do {
            guard let dataFile = Bundle.main.url(forResource: cardsListFilename, withExtension: nil)
            else {
                fatalError("Could not find \(cardsListFilename) in main bundle.")
            }
            
            let data = try Data(contentsOf: dataFile)
            
            if (!data.isEmpty) {
                do {
                    userData.store = try JSONDecoder().decode([Card].self, from: data)
                } catch {
                    fatalError("Could not parse \(cardsListFilename) \n \(error)")
                }
            }
        } catch {
            print("Could not load card list file: \(cardsListFilename)\n \(error)")
        }
    }
    
    func loadUserData(_ fileName: String) {
        var destinationFilename: URL
        do {
            destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            print("Loading user data file: \(destinationFilename)")
            
            if FileManager.default.fileExists(atPath: destinationFilename.path) {
                let data = try Data(contentsOf: destinationFilename)
                if (!data.isEmpty) {
                    do {
                        userData = try JSONDecoder().decode(UserData.self, from: data)
                    } catch {
                        fatalError("Couldn't parse \(destinationFilename) \n \(error)")
                    }
                }
            }
        } catch {
            print("Could not load user data file: \(destinationFilename)\n \(error)")
        }
    }
    
    func saveUserData(_ data: UserData, _ fileName: String) {
        var destinationFilename: URL
        do {
            destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
            print("Saving user data file: \(destinationFilename)")
            let data = try JSONEncoder().encode(data)
            try data.write(to: destinationFilename)
        } catch {
            fatalError("Could not save user data file: \(destinationFilename)\n \(error)")
        }
    }
}
