//
//  Board.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 21/12/22.
//

import Foundation
import SwiftUI

struct Board {
    
    // Define board size
    let BOARD_WIDTH = 7
    let BOARD_HEIGHT = 6
    
    // Save players
    var playerList: [Player] = []
    
    // Board chip
    var board: [[Chip.ChipType]] = []
    
    // Constructor
    init() {
        addPlayersToBoard()
        initEmptyBoard()
    }
    
    // Add players to board
    private mutating func addPlayersToBoard() {
        var player = Player(selectedChipType: .red, selectedChipColor: Chip.ChipColor.redChipColor, playerScore: 0)
        playerList.append(player)
        player = Player(selectedChipType: .yellow, selectedChipColor: Chip.ChipColor.yellowChipColor, playerScore: 0)
        playerList.append(player)
    }
    
    
    // Init an empty board
    private mutating func initEmptyBoard() {
        // Start fill board with empty chips
        for i in 0..<BOARD_HEIGHT {
            board.append([Chip.ChipType]())
            for _ in 0..<BOARD_WIDTH {
                board[i].append(.empty)
            }
        }
    }
    
    public mutating func cleanCurrentBoard() {
        board = []
        initEmptyBoard()
    }
}
