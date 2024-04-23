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
    @State var checkedItems: Set<WordModel> = []
    private let wordAppService: WordAppService = DefaultWordAppService()

    init() {
        let items = wordAppService.getAllTags()
        _tagItem = State(initialValue: items)
        _selection = State(initialValue: items.isEmpty ? TagModel(id: "dummy",
                                                                  tagName: "hello, swift") : items[0])
        let words = wordAppService.getWords(of: selection.id)
        let previousWords = wordAppService.getWordsFromUserDefaults(selection.id)
        if Set(previousWords) != Set(words) {
            _wordList = State(initialValue: words)
            wordAppService.saveWordsToUserDefaults(words.map { $0.toDTO() },
                                                   for: selection.id)
        } else {
            _wordList = State(initialValue: previousWords)
        }
    }

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ForEach(tagItem, id: \.self) { tag in
                    WordListView(deleteWord: { word in
                        deleteWord(word)
                    },
                                 checkedItems: $checkedItems,
                                 itemList: $wordList,
                                 onOrderChange: { newOrderList in
                        wordAppService.saveWordsToUserDefaults(newOrderList.map { $0.toDTO() },
                                                               for: selection.id)
                    })
                        .tabItem {
                            Label(tag.tagName, systemImage: "1.circle")
                        }
                        .tag(tag)
                }
            }
            .onChange(of: selection) { _, _ in
                let newWords = wordAppService.getWords(of: selection.id)
                let previousWords = wordAppService.getWordsFromUserDefaults(selection.id)
                if Set(previousWords) != Set(newWords) {
                    wordList = newWords
                } else {
                    wordList = previousWords
                }
            }
            .fullScreenCover(isPresented: $showInputModal) {
                InputModal(tags: $tagItem,
                           onDismiss: { word in
                    var previousWords = wordAppService.getWordsFromUserDefaults(selection.id)
                    previousWords.append(word)
                    wordList = previousWords
                    wordAppService.saveWordsToUserDefaults(wordList.map { $0.toDTO() },
                                                           for: selection.id)
                    tagItem = wordAppService.getAllTags()
                },
                           onRegisterTag: {
                    tagItem = wordAppService.getAllTags()
                    selection = tagItem[0]
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
            wordList.removeAll(where: { $0 == word })
            wordAppService.saveWordsToUserDefaults(wordList.map { $0.toDTO() },
                                                   for: selection.id)
            checkedItems.remove(word)
        }
    }
}

#Preview {
    BaseTabView()
}
