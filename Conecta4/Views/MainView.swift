//
//  ContentView.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 10/10/22.
//

import SwiftUI

struct MainView: View {
    
    // ViewModel
    @ObservedObject var viewModel: MainViewModel = .init()
    
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
                Text("Turno \(viewModel.currentTurn)")
                    .fontWeight(.medium)
                    .font(.system(size: 30, design: .monospaced))
                    .foregroundColor(Color("textColor"))
                
                ChipTemplate(chipColor: viewModel.currentChipColor, size: 50)
            }
            .padding(.top, 20)
            
            Spacer()
                .frame(height: 10)
            
            // Chip entry
            HStack(spacing: 32) {
                ForEach(0..<viewModel.BOARD_WIDTH, id:\.self) { col in
                    Image(systemName: "chevron.down")
                        .bold()
                        .onTapGesture {
                            // Add chip to board
                            if !viewModel.gameEnded {
                                viewModel.addChipToBoard(chipColumn: col)
                            }
                        }
                }
            }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 18)
                .padding([.bottom], -15)
            
            // Board
            BoardTemplate(viewModel: viewModel)
            
            // ScoreZone
            HStack{
                HStack{
                    ChipTemplate(chipColor: Color("redChip"), size: 20)
                    Text("Player 1")
                        .fontWeight(.semibold)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(Color("textColor"))
                }
                .frame(maxWidth: .infinity)
                
                HStack(spacing: 2) {
                    Text(String(viewModel.redScore))
                        .fontWeight(.heavy)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(Color("textColor"))
                    Text(":")
                        .fontWeight(.heavy)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(Color("textColor"))
                    Text(String(viewModel.yellowScore))
                        .fontWeight(.heavy)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(Color("textColor"))
                }
                .frame(width: 90)
                
                HStack{
                    Text("Player 2")
                        .fontWeight(.semibold)
                        .font(.system(size: 16, design: .monospaced))
                        .foregroundColor(Color("textColor"))
                    ChipTemplate(chipColor: Color("yellowChip"), size: 20)
                    
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .padding([.leading, .trailing], 6)
            
            Spacer()
            
            // Buttons zone
            HStack(spacing: 30){
                Button(action: {}) {
                    HStack(spacing: 0) {
                        Image(systemName: "arrow.clockwise")
                        Text("Restart")
                            .padding(.horizontal)
                    }
                }
                .padding()
                .foregroundColor(Color("textColor"))
                .background(Color("bgButton"))
                .cornerRadius(.infinity)
                
                Button(action: {}) {
                    HStack(spacing: 0) {
                        Image(systemName: "paintbrush")
                        Text("Clear")
                            .padding(.horizontal)
                    }
                }
                .padding()
                .foregroundColor(Color("textColor"))
                .background(Color("bgButton"))
                .cornerRadius(.infinity)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("bgColor"))
    }
}

// Chip pattern
struct ChipTemplate: View {
    let chipColor: Color
    let size: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .fill(chipColor.opacity(0.7))
                .frame(width: size + 10, height: size + 10)
            Circle()
                .fill(chipColor)
                .frame(width: size, height: size)
        }
        .frame(width: size + 10, height: size + 10)
    }
}

// Board template
struct BoardTemplate: View {
    // Viewmodel
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        Grid {
            ForEach(0..<viewModel.board.count, id: \.self) { row in
                GridRow {
                    ForEach(0..<viewModel.board[row].count, id:\.self) { col in
                        // Chip color selection
                        switch viewModel.board[row][col] {
                        case MainViewModel.ChipType.red:
                            Circle()
                                .fill(Color("redChip"))
                        case MainViewModel.ChipType.yellow:
                            Circle()
                                .fill(Color("yellowChip"))
                        default:
                            Circle()
                                .fill(Color("emptyChip"))
                        }
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

