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
    
    // Chip types
    enum ChipType {
        case red, yellow, empty
    }
    
    // Board chip
    @Published var board: [[ChipType]] = []
    
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
    func addChipToBoard() {
        
    }
    
}
