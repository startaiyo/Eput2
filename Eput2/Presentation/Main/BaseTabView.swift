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
    private let dummyWords: [WordModel] = [.init(id: "dummy1",
                                                 word: "このようにタグと単語を登録できます",
                                                 tagID: "dummy1",
                                                 languageCode: Language.japanese.code),
                                           .init(id: "dummy2",
                                                 word: "読み上げたい単語を選択することで順番に読み上げられます",
                                                 tagID: "dummy1",
                                                 languageCode: Language.japanese.code),
                                           .init(id: "dummy3",
                                                 word: "We can add words through + button in TagList",
                                                 tagID: "dummy2",
                                                 languageCode: Language.english.code),
                                           .init(id: "dummy7",
                                                 word: "追加した単語はスワイプで削除できます",
                                                 tagID: "dummy1",
                                                 languageCode: Language.japanese.code),
                                           .init(id: "dummy9",
                                                 word: "単語を長押しすると順番を入れ替えられます。",
                                                 tagID: "dummy1",
                                                 languageCode: Language.japanese.code),
                                           .init(id: "dummy4",
                                                 word: "タグリスト右上の+ボタンから単語を追加しましょう！",
                                                 tagID: "dummy1",
                                                 languageCode: Language.japanese.code),
                                           .init(id: "dummy8",
                                                 word: "All words can be deleted by swipe",
                                                 tagID: "dummy2",
                                                 languageCode: Language.english.code),
                                           .init(id: "dummy10",
                                                 word: "If we hold each row, we can reorder the list",
                                                 tagID: "dummy2",
                                                 languageCode: Language.english.code),
                                           .init(id: "dummy5",
                                                 word: "If we select the words, the words are pronounced in order",
                                                 tagID: "dummy2",
                                                 languageCode: Language.english.code),
                                           .init(id: "dummy6",
                                                 word: "Let's add the words for now!",
                                                 tagID: "dummy2",
                                                 languageCode: Language.english.code)]
    private let dummyTags: [TagModel] = [.init(id: "dummy1",
                                               tagName: "Eputの説明"),
                                         .init(id: "dummy2",
                                               tagName: "Explanation in English")]

    init() {
        let items = wordAppService.getAllTags()
        _tags = State(initialValue: items.isEmpty ? dummyTags : items)
        _selectedTag = State(
            initialValue: items.isEmpty ? dummyTags[0] : items[0]
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
        
        var words = wordAppService.getWords(of: selectedTag.id)
        let previousWords = wordAppService.getWordsFromUserDefaults(selectedTag.id)
        if words.isEmpty {
            words = dummyWords.filter { $0.tagID == selectedTag.id }
        }
        _words = State(initialValue: Set(previousWords) != Set(words) ? words : previousWords)
    }

    var body: some View {
        NavigationStack {
            VStack {
                if tags.isEmpty && words.isEmpty {
                    VStack {
                        Image("empty-list")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .overlay(.white.opacity(0.5))
                            .padding()
                        
                        Text("まだタグが登録されていません")
                            .font(.system(size: 20))
                            .overlay(.white.opacity(0.5))
                            .padding()
                        
                        Text("右上の+ボタンから追加してください")
                            .overlay(.white.opacity(0.5))
                            .font(.system(size: 15))
                    }
                } else {
                    List {
                        ForEach(tags) { tag in
                            NavigationLink(destination:
                                            WordListView(
                                                deleteWord: { word in
                                                    deleteWord(word)
                                                },
                                                checkedWords: $checkedWords,
                                                words: $words,
                                                onOrderChange: { newOrderList in
                                                    wordAppService.saveWordsToUserDefaults(
                                                        newOrderList.map { $0.toDTO() },
                                                        for: tag.id
                                                    )
                                                },
                                                selectedTag: selectedTag,
                                                onTapGesture: {
                                                    selectedTag = tag
                                                    let newWords = wordAppService.getWords(of: tag.id)
                                                    let previousWords = wordAppService.getWordsFromUserDefaults(tag.id)
                                                    if dummyTags.contains(selectedTag) {
                                                        words = dummyWords.filter { $0.tagID == tag.id }
                                                    } else {
                                                        words = Set(previousWords) != Set(newWords) ? newWords : previousWords
                                                    }
                                                }
                                            )
                            ) {
                                Text(tag.tagName)
                            }
                        }
                    }
                }
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
                        if tag.id == selectedTag.id {
                            words = previousWords
                        } else {
                            words = wordAppService.getWordsFromUserDefaults(selectedTag.id)
                        }
                        tags = wordAppService.getAllTags()
                    },
                    onRegisterTag: {
                        tags = wordAppService.getAllTags()
                        selectedTag = tags[0]
                    }
                )
                .onDisappear {
                    if dummyTags.contains(selectedTag) {
                        tags = dummyTags
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("+") {
                        showInputModal.toggle()
                        if dummyTags.contains(selectedTag) {
                            tags = []
                        }
                    }
                    .font(.title3)
                    .padding()
                }
            }
            .navigationTitle("タグリスト")
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
