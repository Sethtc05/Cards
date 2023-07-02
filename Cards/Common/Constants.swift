import Foundation

struct Constants {

    // Play board constants
    struct Play {
        static let ColumnCount = 3;
        static let RowCount = 5;
    }
    
    struct Fetch {
        // Name of files store in the applications document directory.
        static let  CardsListFilename = "cards.json";
        static let  UsersListFilename = "users.json";
        static let  UserDataFilename = "userData.json";
    }
}
