//
//  BaseTabView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI

struct BaseTabView: View {
    @State private var selectedTag: TagModel
    @State private var tags: [TagModel] = []
    @State private var showInputModal = false
    @State private var words: [WordModel] = []
    @State private var checkedWords: Set<WordModel> = []
    
    private let wordAppService: any WordAppService = DefaultWordAppService()
    
    init() {
        let items = wordAppService.getAllTags()
        _tags = State(initialValue: items)
        _selectedTag = State(
            initialValue: items.isEmpty ? TagModel(id: "dummy", tagName: "hello, swift") : items[0]
        )
        items.forEach { item in
            let words = wordAppService.getWords(of: item.id)
            let previousWords = wordAppService.getWordsFromUserDefaults(item.id)
            if Set(previousWords) != Set(words) {
                wordAppService.saveWordsToUserDefaults(
                    words.map { $0.toDTO() },
                    for: selectedTag.id
                )
            }
        }
        
        let words = wordAppService.getWords(of: selectedTag.id)
        let previousWords = wordAppService.getWordsFromUserDefaults(selectedTag.id)
        _words = State(initialValue: Set(previousWords) != Set(words) ? words : previousWords)
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTag) {
                if tags.isEmpty && words.isEmpty {
                    VStack {
                        Image("empty-list")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .overlay(.white.opacity(0.5))
                            .padding()
                        
                        Text("まだワードが登録されていません")
                            .font(.system(size: 20))
                            .overlay(.white.opacity(0.5))
                            .padding()
                        
                        Text("右上の+ボタンから追加してください")
                            .overlay(.white.opacity(0.5))
                            .font(.system(size: 15))
                    }
                } else {
                    ForEach(tags) { tag in
                        WordListView(
                            deleteWord: { word in
                                deleteWord(word)
                            },
                            checkedWords: $checkedWords,
                            words: $words,
                            onOrderChange: { newOrderList in
                                wordAppService.saveWordsToUserDefaults(
                                    newOrderList.map { $0.toDTO() },
                                    for: selectedTag.id
                                )
                            },
                            selectedTag: selectedTag
                        )
                        .tabItem {
                            Label(tag.tagName, systemImage: "tag")
                        }
                        .tag(tag)
                    }
                }
            }
            .onChange(of: selectedTag) { _, _ in
                let newWords = wordAppService.getWords(of: selectedTag.id)
                let previousWords = wordAppService.getWordsFromUserDefaults(selectedTag.id)
                words = Set(previousWords) != Set(newWords) ? newWords : previousWords
            }
            .fullScreenCover(isPresented: $showInputModal) {
                InputModal(
                    tags: $tags,
                    onDismiss: { tag, word in
                        var previousWords = wordAppService.getWordsFromUserDefaults(tag.id)
                        previousWords.append(word)
                        wordAppService.saveWordsToUserDefaults(
                            previousWords.map { $0.toDTO() },
                            for: tag.id
                        )
                        words = if tag.id == selectedTag.id {
                            previousWords
                        } else {
                            wordAppService.getWordsFromUserDefaults(selectedTag.id)
                        }
                        tags = wordAppService.getAllTags()
                    },
                    onRegisterTag: {
                        tags = wordAppService.getAllTags()
                        selectedTag = tags[0]
                    }
                )
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
}

private extension BaseTabView {
    func deleteWord(_ word: WordModel) {
        Task {
            try wordAppService.deleteWord(word.toDTO())
            words.removeAll(where: { $0 == word })
            wordAppService.saveWordsToUserDefaults(
                words.map { $0.toDTO() },
                for: selectedTag.id
            )
            checkedWords.remove(word)
        }
    }
}

#Preview {
    BaseTabView()
}
