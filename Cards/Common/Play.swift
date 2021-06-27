import Foundation
import SwiftUI

class Play: ObservableObject  {
    
    @Published var board: Matrix<PlayOption>
    @Published var columns: Int
    @Published var rows: Int
    @Published var waitSeconds: Int
    @Published var isRunning: Bool
    @Published var isEnabled: Bool
    
    var playTimer: Timer?
    var waitTimer: Timer?
    var winFunc: (_ balance: Double) -> Void
    
    var runCount: Int
    var inactiveBackgroundColor: Color
    var inactiveForegroundColor: Color
    
    private var landedRowIndex: Int
    private var landedColIndex: Int
    
    init() {
        
        runCount = 0
        waitSeconds = 0
        isRunning = false
        isEnabled = true
        
        landedRowIndex = 0
        landedColIndex = 0
        
        print("Initialising Play...")
        
        inactiveBackgroundColor = Color(UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.0))
        inactiveForegroundColor = Color(UIColor(red: 0.4667, green: 0.4667, blue: 0.4667, alpha: 1.0))
        winFunc = { balance in print("Win \(balance)!") }
        
        let columnCount = 3
        let rowCount = 5
        
        columns = columnCount
        rows = rowCount
        board = Matrix(
            rows: rowCount,
            columns: columnCount,
            defaultValue: PlayOption(
                value: 0.00,
                backgroundColor: inactiveBackgroundColor,
                foregroundColor: inactiveForegroundColor))

        generateValues(col: columnCount, row: rowCount)
    }
    
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
    
    func selectRandomOption() {
        self.landedColIndex = Int.random(in: 0...(self.columns - 1))
        self.landedRowIndex = Int.random(in: 0...(self.rows - 1))
        
        let option = self.board[self.landedRowIndex, self.landedColIndex];
        option.backgroundColor = Color.green
        option.foregroundColor = Color.white
        
        self.board[self.landedRowIndex, self.landedColIndex] = option
    }
    
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
    
    func start(winFunc: @escaping (_ balance: Double) -> Void) {
        if (!self.isRunning && self.isEnabled) {
            self.winFunc = winFunc
            print("Play...")
            isRunning = true
            playTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(playTimerFunc), userInfo: nil, repeats: true)
        }
    }
    
    @objc func playTimerFunc() {
        runCount += 1
        resetOptions()
        selectRandomOption()
        
        if runCount == 50 {
            playTimer?.invalidate()
            runCount = 0
            waitSeconds = 60
            self.isRunning = false
            self.isEnabled = false
            winFunc(self.board[self.landedRowIndex, self.landedColIndex].value)
            print("Stop...")
            waitTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(waitTimerFunc), userInfo: nil, repeats: true)
        }
    }
    
    @objc func waitTimerFunc() {
        print("Wait \(waitSeconds)")
        waitSeconds -= 1
        if (waitSeconds == 0) {
            waitTimer?.invalidate()
            isEnabled = true
        }
    }
}

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
