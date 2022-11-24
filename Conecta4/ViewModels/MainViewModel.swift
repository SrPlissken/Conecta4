//
//  MainViewModel.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 16/11/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    
    // Define board size
    let BOARD_WIDTH = 7
    let BOARD_HEIGHT = 6
    // Max ocurrences for win
    let OCURRENCES_LIMIT = 4
    // Save game state
    var gameEnded = false
    
    // Store current chip type and color
    @Published var currentChipType = ChipType.red
    @Published var currentChipColor: Color = Color("redChip")
    
    // Track current tuen
    @Published var currentTurn: Int = 1
    
    // Track player points
    @Published var redScore = 0
    @Published var yellowScore = 0
    
    // Chip types
    enum ChipType {
        case red, yellow, empty
    }
    
    // Board chip
    @Published var board: [[ChipType]] = []
    
    // Constructor
    init() {
        initEmptyBoard()
    }
    
    // Init an empty board
    private func initEmptyBoard() {
        // Start fill board with empty chips
        for i in 0..<BOARD_HEIGHT {
            board.append([ChipType]())
            for _ in 0..<BOARD_WIDTH {
                board[i].append(.empty)
            }
        }
    }
    
    // Add chip to board
    func addChipToBoard(chipColumn: Int) {
        // Var control
        var isWin: Bool = false
        var allowSwap = false
        for row in 0..<board.count {
            // Checks if there is a chip, then add chip on top
            if row != 0 && board[row][chipColumn] != ChipType.empty {
                // First row cannot be filled if chip exist
                if board[row - 1][chipColumn] != ChipType.empty {
                    break
                }
                board[row - 1][chipColumn] = currentChipType
                isWin = checkWin(currentRow: row - 1, currentCol: chipColumn)
                allowSwap = true
                break
            }
            // Last row needs to filled with chip
            else if row == board.count - 1 {
                board[row][chipColumn] = currentChipType
                isWin = checkWin(currentRow: row, currentCol: chipColumn)
                allowSwap = true
            }
        }
        // Check win or allow change
        if isWin {
            gameEnded = true
            if currentChipType == .red {
                redScore += 1
            }
            else {
                yellowScore += 1
            }
        }
        else if allowSwap{
            swapChipTurn()
        }
    }
    
    // Swap chip turn
    func swapChipTurn() {
        switch(currentChipType) {
        case .red:
            currentChipType = .yellow
            currentChipColor = Color("yellowChip")
        case .yellow:
            currentChipType = .red
            currentChipColor = Color("redChip")
        default:
            currentChipType = .red
        }
        currentTurn += 1
    }
    
    // Check if player win
    func checkWin(currentRow: Int, currentCol: Int) -> Bool {
        let isWinH = checkHorizontalWin(currentRow: currentRow)
        let isWinV = checkVerticalWin(currentRow: currentRow, currentCol: currentCol)
        let isWinD = checkDiagonalWin(currentRow: currentRow, currentCol: currentCol)
        let isWinDInv = checkDiagonalWinInv(currentRow: currentRow, currentCol: currentCol)
        return isWinH || isWinV || isWinD || isWinDInv
    }
    
    // Check if player wins horizontal game
    func checkHorizontalWin(currentRow: Int) -> Bool {
        var ocurrences = 0
        for element in 0..<board[currentRow].count {
            if board[currentRow][element] != currentChipType {
                ocurrences = 0
                continue
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
        }
        return false
    }
    
    // Check if player wins vertical game
    func checkVerticalWin(currentRow: Int, currentCol: Int) -> Bool {
        var ocurrences = 0
        for row in currentRow..<board.count {
            if board[row][currentCol] != currentChipType {
                ocurrences = 0
                continue
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
        }
        return false
    }
    
    // Check if player wins with diagonal game
    func checkDiagonalWin(currentRow: Int, currentCol: Int) -> Bool {
        var matchCol = currentCol
        var ocurrences = 0
        // Start looking ascendant
        for row in (0...currentRow).reversed() {
            if board[row][matchCol] != currentChipType {
                matchCol += 1
                break
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
            // Next col
            matchCol += 1
            if matchCol > board[row].count - 1 {
                break
            }
        }
        
        // Start looking descendant
        matchCol = currentCol - 1
        for row in currentRow + 1..<board.count {
            if matchCol < 0 || board[row][matchCol] != currentChipType {
                matchCol -= 1
                break
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
            // Next col
            matchCol -= 1
        }
        
        return false
    }
    
    // Check if player wins with inverse diagonal game
    func checkDiagonalWinInv(currentRow: Int, currentCol: Int) -> Bool {
        var matchCol = currentCol
        var ocurrences = 0
        // Start looking ascendant
        for row in (0...currentRow).reversed() {
            if matchCol < 0 || board[row][matchCol] != currentChipType {
                matchCol -= 1
                break
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
            // Next col
            matchCol -= 1
        }
        
        // Start looking descendant
        if currentCol != board[currentRow].count - 1 {
            matchCol = currentCol + 1
        }
        else {
            matchCol = currentCol
        }
        
        for row in currentRow + 1..<board.count {
            if board[row][matchCol] != currentChipType {
                matchCol += 1
                break
            }
            else {
                ocurrences += 1
                // Check for win
                if ocurrences == OCURRENCES_LIMIT {
                    return true
                }
            }
            // Next col
            matchCol += 1
            if matchCol > board[row].count - 1 {
                break
            }
        }
        
        return false
    }
    
    // Allow to restart current game
    func restartCurrentGame() {
        // Reset board
        board = []
        initEmptyBoard()
        
        // If game ends, start next player
        if gameEnded {
            swapChipTurn()
            gameEnded = false
        }
        else {
            currentChipType = .red
            currentChipColor = Color("redChip")
        }
        // Reset turn
        currentTurn = 0
    }
    
}
