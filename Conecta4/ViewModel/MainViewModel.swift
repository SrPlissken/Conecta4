//
//  MainViewModel.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 16/11/22.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {
    // Max ocurrences for win
    let OCURRENCES_LIMIT = 4
    // Save game state
    var gameEnded = false
    
    // Track current tuen
    @Published var currentTurn: Int = 1
    
    // Init board
    @Published var gameBoard: Board = Board.init()
    
    // Store current chip type and color
    @Published var currentChipType = Chip.ChipType.red
    @Published var currentChipColor: Color = Chip.ChipColor.redChipColor
    
    func addChipToBoard(chipColumn: Int) {
        // Var control
        var isWin: Bool = false
        var allowSwap = false
        for row in 0..<gameBoard.board.count {
            // Checks if there is a chip, then add chip on top
            if row != 0 && gameBoard.board[row][chipColumn] != Chip.ChipType.empty{
                // First row cannot be filled if chip exist
                if gameBoard.board[row - 1][chipColumn] != Chip.ChipType.empty {
                    break
                }
                gameBoard.board[row - 1][chipColumn] = currentChipType
                isWin = checkWin(currentRow: row - 1, currentCol: chipColumn)
                allowSwap = true
                break
            }
            // Last row needs to filled with chip
            else if row == gameBoard.board.count - 1 {
                gameBoard.board[row][chipColumn] = currentChipType
                isWin = checkWin(currentRow: row, currentCol: chipColumn)
                allowSwap = true
            }
        }
        // Check win or allow change
        if isWin {
            gameEnded = true
            if currentChipType == Chip.ChipType.red {
                gameBoard.playerList[0].playerScore += 1
            }
            else {
                gameBoard.playerList[1].playerScore += 1
            }
        }
        else if allowSwap{
            swapChipTurn()
        }
    }
    
    func swapChipTurn() {
        switch(currentChipType) {
        case Chip.ChipType.red:
            currentChipType = gameBoard.playerList[1].selectedChipType
            currentChipColor = gameBoard.playerList[1].selectedChipColor
        case Chip.ChipType.yellow:
            currentChipType = gameBoard.playerList[0].selectedChipType
            currentChipColor = gameBoard.playerList[0].selectedChipColor
        default:
            currentChipType = gameBoard.playerList[0].selectedChipType
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
        for element in 0..<gameBoard.board[currentRow].count {
            if gameBoard.board[currentRow][element] != currentChipType {
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
        for row in currentRow..<gameBoard.board.count {
            if gameBoard.board[row][currentCol] != currentChipType {
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
            if gameBoard.board[row][matchCol] != currentChipType {
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
            if matchCol > gameBoard.board[row].count - 1 {
                break
            }
        }
        
        // Start looking descendant
        matchCol = currentCol - 1
        for row in currentRow + 1..<gameBoard.board.count {
            if matchCol < 0 || gameBoard.board[row][matchCol] != currentChipType {
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
            if matchCol < 0 || gameBoard.board[row][matchCol] != currentChipType {
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
        if currentCol != gameBoard.board[currentRow].count - 1 {
            matchCol = currentCol + 1
        }
        else {
            matchCol = currentCol
        }
        
        for row in currentRow + 1..<gameBoard.board.count {
            if gameBoard.board[row][matchCol] != currentChipType {
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
            if matchCol > gameBoard.board[row].count - 1 {
                break
            }
        }
        
        return false
    }
    
    // Allow to restart current game
    func restartCurrentGame() {
        // Clean current board
        gameBoard.cleanCurrentBoard()
        
        // If game ends, start next player
        if gameEnded {
            swapChipTurn()
            gameEnded = false
        }
        else {
            currentChipType = Chip.ChipType.red
            currentChipColor = Chip.ChipColor.redChipColor
        }
        // Reset turn
        currentTurn = 0
    }
    
    // Init empty board and clean player scores
    func resetPlayerScores() {
        gameBoard = Board.init()
    }
    
}
