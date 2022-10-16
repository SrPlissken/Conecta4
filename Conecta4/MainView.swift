//
//  ContentView.swift
//  Conecta4
//
//  Created by Victor Melcon Diez on 10/10/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Conecta 4")
                    .fontWeight(.heavy)
                    .font(.system(.title, design: .monospaced))
                    .foregroundColor(Color("textColor"))
            }
            
            Divider()
            
            VStack(spacing: 10) {
                Text("Turno 1")
                    .fontWeight(.medium)
                    .font(.system(size: 30, design: .monospaced))
                    .foregroundColor(Color("textColor"))
                
                ChipTemplate(chipColor: Color("redChip"))
            }
            .padding(.top, 20)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


