//
//  BaseTabView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI

struct BaseTabView: View {
    @State var selection: TagModel
    @State var tagItem: [TagModel] = []
    @State var showInputModal = false
    @State var wordList = [WordModel]()
    private let wordAppService: WordAppService = DefaultWordAppService()
    init() {
        let items = wordAppService.getAllTags()
        _tagItem = State(initialValue: items)
        _selection = State(initialValue: items[0])
        let words = wordAppService.getWords(of: selection.id)
        _wordList = State(initialValue: words)
    }

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(tagItem, id: \.self) { tag in
                    WordListView(deleteWord: { word in
                        
                    },
                                 itemList: $wordList)
                        .tabItem {
                            Label(tag.tagName, systemImage: "1.circle")
                        }
                        .tag(tag)
                }
            }
            .onChange(of: selection) { _, _ in
                wordList = wordAppService.getWords(of: selection.id)
            }
            .sheet(isPresented: $showInputModal) {
                InputModal(tags: $tagItem,
                           onDismiss: { word in
                    wordList = wordAppService.getWords(of: selection.id)
                    wordList.append(word)
                },
                           onRegisterTag: {
                    tagItem = wordAppService.getAllTags()
                })
            }
            .toolbar {
                Button("+") {
                    showInputModal.toggle()
                }
                .font(.title3)
                .padding()
            }
        }
    }

    func deleteWord(_ word: WordModel) {
        Task {
            try wordAppService.deleteWord(word.toDTO())
        }
    }
}

#Preview {
    BaseTabView()
}
