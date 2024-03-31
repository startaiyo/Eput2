//
//  BaseTabView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI

struct BaseTabView: View {
    @State var selection = 1
    @State var tagItem = [TagModel(id: "1", tagName: "hoge"), TagModel(id: "2", tagName: "fuga")]
    @State var showInputModal = false

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(tagItem, id: \.id) { tag in
                    WordListView()
                        .tabItem {
                            Label(tag.tagName, systemImage: "1.circle")
                        }
                        .tag(tag.tagName)
                }
            }
            .toolbar {
                Button("+") {
                    showInputModal.toggle()
                }
                .font(.title3)
                .padding()
            }
            .sheet(isPresented: $showInputModal) {
                InputModal()
            }
        }
    }
}

#Preview {
    BaseTabView()
}
