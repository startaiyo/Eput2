//
//  BaseTabView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI

struct BaseTabView: View {
    @State var selection = 1

    var body: some View {
        TabView(selection: $selection) {
            
            ContentView()   // Viewファイル①
                .tabItem {
                    Label("Page1", systemImage: "1.circle")
                }
                .tag(1)
            
            ContentView()   // Viewファイル②
                .tabItem {
                    Label("Page2", systemImage: "2.circle")
                }
                .tag(2)
            
            ContentView()  // Viewファイル③
                .tabItem {
                    Label("Page3", systemImage: "3.circle")
                }
                .tag(3)
            
        }
    }
}

#Preview {
    BaseTabView()
}
