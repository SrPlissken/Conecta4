//
//  ContentView.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 10/10/22.
//

import SwiftUI

struct MainView: View {
    
    // Define board size
    static let BOARD_WIDTH = 7
    static let BOARD_HEIGHT = 6
    
    
    var body: some View {
        VStack(spacing: 10) {
            // Title
            HStack {
                Text("Conecta 4")
                    .fontWeight(.heavy)
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(Color("textColor"))
            }
            
            Divider()
            
            // Chip turn
            VStack(spacing: 10) {
                Text("Turno 1")
                    .fontWeight(.medium)
                    .font(.system(size: 30, design: .monospaced))
                    .foregroundColor(Color("textColor"))
                
                ChipTemplate(chipColor: Color("redChip"))
            }
            .padding(.top, 20)
            
            Spacer()
                .frame(height: 10)
            
            // Board
            BoardTemplate(rows: MainView.BOARD_HEIGHT, cols: MainView.BOARD_WIDTH)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("bgColor"))
    }
}

// Chip pattern
struct ChipTemplate: View {
    let chipColor: Color
    var body: some View {
        ZStack {
            Circle()
                .fill(chipColor.opacity(0.7))
                .frame(width: 60, height: 60)
            Circle()
                .fill(chipColor)
                .frame(width: 50, height: 50)
        }
        .frame(width: 60, height: 60)
    }
}

// Board template
struct BoardTemplate: View {
    // Board size
    let rows: Int
    let cols: Int
    
    var body: some View {
        Grid {
            ForEach(0..<rows, id:\.self) { row in
                GridRow {
                    ForEach(0..<cols, id:\.self) { col in
                        Circle()
                            .fill(Color("emptyChip"))
                    }
                }
            }
        }
        .padding(6)
        .background(Color("bgBoard"))
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

