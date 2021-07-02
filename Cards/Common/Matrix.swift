import Foundation

// A Matrix is used as a multi-dimensional array or grid for the play tabs buttons.
// Each button is represented in the matrix by column and row containing a money amount (dollars and cents) to win.

struct Matrix<T> {
    
    let rows: Int, columns: Int
    var grid: [T]
    
    // Initialise the matrix.
    init(rows: Int, columns: Int,defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    
    // Check if a specific row and column index exists in this matrix.
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    
    // Retrieve or set a grid value based on location by row and column index.
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}
