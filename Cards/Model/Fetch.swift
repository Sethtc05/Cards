import Foundation

class Fetch: ObservableObject {
    
    @Published var storeCards: [Card]
    @Published var collectionCards: [Card]
    @Published var balanceAmount: Double
    
    var cardsListFilename = "cards.json";
    var storeListFilename = "store.json";
    var collectionListFilename = "collection.json";
     
    init() {
        storeCards = []
        collectionCards = []
        balanceAmount = 0.0
        
        storeCards = loadStoreData(cardsListFilename, storeListFilename)
        collectionCards = loadCollectionData(collectionListFilename)
        
        storeCards = storeCards.sorted(by: { $0.name < $1.name })
        collectionCards = collectionCards.sorted(by: { $0.name < $1.name })
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func buy(_ card: Card) {
        storeCards = removeData(card, storeCards, storeListFilename)
        collectionCards = addData(card, collectionCards, collectionListFilename)
    }
    
    func sell(_ card: Card) {
        collectionCards = removeData(card, collectionCards, collectionListFilename)
        storeCards = addData(card, storeCards, storeListFilename)
    }
    
    func addData(_ card: Card, _ list: [Card], _ fileName: String) -> [Card] {
        var updatedList = list
        updatedList.append(card)
        saveData(updatedList, fileName)

        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    func removeData(_ card: Card, _ list: [Card], _ fileName: String) -> [Card] {
        let updatedList = list.filter(){$0 != card}
        saveData(updatedList, fileName)
        
        let sortedList = updatedList.sorted(by: { $0.name < $1.name })
        return sortedList
    }
    
    func saveData<T: Encodable>(_ data: [T], _ fileName: String) {
        let destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        print("Destination file: \(destinationFilename)")
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(data)
            try data.write(to: destinationFilename)
        } catch {
            fatalError("Couldn't save \(destinationFilename) \n \(error)")
        }
    }
    
    func loadCollectionData<T: Decodable>(_ fileName: String) -> T {
        let destinationFilename = getDocumentsDirectory().appendingPathComponent(fileName)
        print("Destination file: \(destinationFilename)")
        
        do {
            if !FileManager.default.fileExists(atPath: destinationFilename.path) {
                return [T]() as! T
            }
            
            let collectionData = try Data(contentsOf: destinationFilename)
            if (collectionData.isEmpty) {
                return [T]() as! T
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: collectionData)
            } catch {
                fatalError("Couldn't parse \(destinationFilename) \n \(error)")
            }
        } catch {
            print("Couldn't load \(destinationFilename) :\n \(error)")
            return [T]() as! T
        }
    }
    
    func loadStoreData<T: Decodable>(_ modelDataFileName: String, _ outputFileName: String) -> T {
        let modelData: Data

        guard let modelDataFile = Bundle.main.url(forResource: modelDataFileName, withExtension: nil)
        else {
            fatalError("Couldn't find \(modelDataFileName) in main bundle.")
        }

        do {
            modelData = try Data(contentsOf: modelDataFile)
            
            let destinationFilename = getDocumentsDirectory().appendingPathComponent(outputFileName)
            print("Destination file: \(destinationFilename)")
            
            if !FileManager.default.fileExists(atPath: destinationFilename.path) {
                try modelData.write(to: destinationFilename)
            }
            
            let storeData: Data
            do {
                storeData = try Data(contentsOf: destinationFilename)
            } catch {
                fatalError("Couldn't load \(destinationFilename) :\n \(error)")
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: storeData)
            } catch {
                fatalError("Couldn't parse \(destinationFilename) \n \(error)")
            }
        } catch {
            fatalError("Couldn't load \(modelDataFileName) from main bundle:\n\(error)")
        }
    }
}
