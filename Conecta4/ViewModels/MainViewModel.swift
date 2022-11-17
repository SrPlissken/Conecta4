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
    
    // Store current chip type and color
    @Published var currentChipType = ChipType.red
    @Published var currentChipColor: Color = Color("redChip")
    
    // Track current tuen
    @Published var currentTurn: Int = 1
    
    // Chip types
    enum ChipType {
        case red, yellow, empty
    }
    
    // Board chip
    @Published var board: [[ChipType]] = []
    
    // Constructor
    init() {
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
        for row in 0..<board.count {
            // Checks if there is a chip, then add chip on top
            if row != 0 && board[row][chipColumn] != ChipType.empty {
                board[row - 1][chipColumn] = currentChipType
                break
            }
            // Last row needs to filled with chip
            else if row == board.count - 1 {
                board[row][chipColumn] = currentChipType
            }
        }
        // Change turn
        swapChipTurn()
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
    
}
