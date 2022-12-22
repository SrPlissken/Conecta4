//
//  Chips.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 21/12/22.
//

import Foundation
import SwiftUI

class Chip {
    
    // Chip types
    enum ChipType {
        case red, yellow, empty
    }
    
    // Chip colors
    enum ChipColor {
        static let redChipColor = Color("redChip")
        static let yellowChipColor = Color("yellowChip")
        static let emptyChipColor = Color("emptyChip")
    }
}
