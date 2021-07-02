import Foundation
import SwiftUI

// A little game of 'spin to win' to earn more money to buy cards with.

class Play: ObservableObject  {
    
    @Published var board: Matrix<PlayOption> // The game board made up of a prize (money).
    @Published var columns: Int
    @Published var rows: Int
    @Published var waitSeconds: Int
    @Published var isRunning: Bool // Is the game currently running? Helpful to stop things happening again..
    @Published var isEnabled: Bool // Should we be letting the user play again yet?
    
    var playTimer: Timer? // Spin, spin, spin, I want to win!
    var waitTimer: Timer? // After the user has won a prize we need to make them wait before playing again.
    var winFunc: (_ balance: Double) -> Void // What should we do once a prize has been chosen?
    
    var runCount: Int
    var inactiveBackgroundColor: Color
    var inactiveForegroundColor: Color
    
    private var landedRowIndex: Int // Which row did the spinner land on?
    private var landedColIndex: Int // Which column did the spinner land on?
    
    init() {
        
        runCount = 0
        waitSeconds = 0
        isRunning = false
        isEnabled = true
        
        landedRowIndex = 0
        landedColIndex = 0
        
        inactiveBackgroundColor = Color(UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0)) // grey RGB
        inactiveForegroundColor = Color(UIColor(red: 0.4667, green: 0.4667, blue: 0.4667, alpha: 1.0)) // blackish RGB
        winFunc = { balance in print("Win \(balance)!") } // If what happens when the user wins isn't setup then please let me know.
        
        // Set me up a play board with 3 columns and 5 rows please :)
        let columnCount = 3
        let rowCount = 5
        
        columns = columnCount
        rows = rowCount
        
        // Build the play board.
        board = Matrix(
            rows: rowCount,
            columns: columnCount,
            defaultValue: PlayOption(
                value: 0.00,
                backgroundColor: inactiveBackgroundColor,
                foregroundColor: inactiveForegroundColor))

        // Give the play board some money options.
        generateValues(col: columnCount, row: rowCount)
    }
    
    // Create the play board with a specified number of columns and rows.
    func generateValues(col: Int, row: Int) {
        
        let maxRowIndex = (row - 1);
        let maxColIndex = (col - 1);
        
        for rowIndex in 0...maxRowIndex {
            for colIndex in 0...maxColIndex {
                let value = Double.random(in: 0.01...1.50);
                board[rowIndex, colIndex] = PlayOption(
                    value: value,
                    backgroundColor: inactiveBackgroundColor,
                    foregroundColor: inactiveForegroundColor);
            }
        }
    }
    
    // Knowing what the play board looks like, pick a number, any number...
    func selectRandomOption() {
        
        // Pick a random column and row within the boundaries of the play board size.
        self.landedColIndex = Int.random(in: 0...(self.columns - 1))
        self.landedRowIndex = Int.random(in: 0...(self.rows - 1))
        
        let option = self.board[self.landedRowIndex, self.landedColIndex];
        
        // Make it visually obivious which board square is either being checked or has be landed on.
        option.backgroundColor = Color.green
        option.foregroundColor = Color.white
        
        self.board[self.landedRowIndex, self.landedColIndex] = option
    }
    
    // Once done put the play board back to what it was when we started.
    func resetOptions() {
        let maxRowIndex = (rows - 1);
        let maxColIndex = (columns - 1);
        
        for rowIndex in 0...maxRowIndex {
            for colIndex in 0...maxColIndex {
                let option = board[rowIndex, colIndex]
                board[rowIndex, colIndex] = PlayOption(
                    value: option.value,
                    backgroundColor: inactiveBackgroundColor,
                    foregroundColor: inactiveForegroundColor);
            }
        }
    }
    
    // Lets play!
    func start(winFunc: @escaping (_ balance: Double) -> Void) {
        if (!self.isRunning && self.isEnabled) {
            self.winFunc = winFunc
            isRunning = true
            
            // Every 0.1 second pick a new square on the play board until we stop and 'land' on the winner.
            playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(playTimerFunc), userInfo: nil, repeats: true)
        }
    }
    
    // What to do while to spinner is spinning.
    @objc func playTimerFunc() {
        runCount += 1 // Increase the spinner count so we can stop it at a specific time.
        resetOptions() // Set all square on the board to 'unselected'.
        selectRandomOption() // Pick a random square for this spin cycle.
        
        // Once we have spun around 50 times we stop on the 50th spin. Don't worry it spins fast!
        if runCount == 50 {
            
            playTimer?.invalidate() // Stop the spin timer aka stop playing.
            runCount = 0 // Reset the spin count.
            waitSeconds = 60 // After we have won something we must wait (60 seconds) to play again.
            
            // We're won so lets play again when the application is ready.
            self.isRunning = false
            self.isEnabled = false
            
            // Let the caller know we have finished. Let the caller do whatever it needs to once finished.
            winFunc(self.board[self.landedRowIndex, self.landedColIndex].value)
            
            // Start waiting before playing again.
            waitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(waitTimerFunc), userInfo: nil, repeats: true)
        }
    }
    
    // Each second we wait.
    @objc func waitTimerFunc() {
        print("Wait \(waitSeconds)") // Let me know where we are up to.
        
        // Update how long we have left to wait.
        waitSeconds -= 1
        
        // We've waited the full amount of time so let's allow the user to play again.
        if (waitSeconds == 0) {
            waitTimer?.invalidate() // Stop the waiting, lets play!
            isEnabled = true
        }
    }
}

// A data structure that represents a single square on the play board.
class PlayOption: ObservableObject {
    
    @Published var value: Double
    @Published var backgroundColor: Color
    @Published var foregroundColor: Color
    
    init(value: Double, backgroundColor: Color, foregroundColor: Color) {
        self.value = value
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
    }
}
