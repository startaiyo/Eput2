//
//  WordListView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI
import AVFoundation

struct WordListView: View {
    let deleteWord: (WordModel) -> Void
    @Binding var checkedWords: Set<WordModel>
    @Binding var words: [WordModel]
    let onOrderChange: (_ newOrder: [WordModel]) -> Void
    let selectedTag: TagModel
    let onTapGesture: () -> Void

    @State private var selectedWord: WordModel?
    
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            VStack {
                if !words.isEmpty {
                    List(selection: $selectedWord) {
                        ForEach(words) { item in
                            WordCell(
                                text: item.word,
                                checkBox: CheckBoxView(isChecked: binding(for: item))
                            )
                            .listRowBackground(Color.white)
                            .swipeActions(allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteWord(item)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .onMove { from, to in
                            words.move(fromOffsets: from, toOffset: to)
                            onOrderChange(words)
                        }
                    }
                    .background(Color(uiColor: .systemGray6))

                    Button("テキスト読み上げ") {
                        readText()
                    }
                    .disabled(checkedWords.isEmpty)
                    .buttonStyle(.bordered)
                    .tint(.red)
                } else {
                    VStack {
                        Image("empty-list")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .aspectRatio(contentMode: .fit)
                            .overlay(.white.opacity(0.5))
                            .padding()

                        Text("まだワードが登録されていません")
                            .font(.system(size: 20))
                            .overlay(.white.opacity(0.2))
                            .padding()

                        Text("右上の+ボタンから追加してください")
                            .overlay(.white.opacity(0.2))
                            .font(.system(size: 15))
                    }
                }
            }
            .background(Color(uiColor: .systemGray6))
        }.onAppear {
            onTapGesture()
        }
    }
}

private extension WordListView {
    func readText() {
        checkedWords
            .filter { $0.tagID == selectedTag.id }
            .sorted { (index1, index2) in
                if let firstIndex = words.firstIndex(of: index1),
                   let secondIndex = words.firstIndex(of: index2) {
                    return firstIndex < secondIndex
                } else {
                    return false
                }
            }
            .forEach {
                let utterText = AVSpeechUtterance(string: $0.word)
                utterText.voice = AVSpeechSynthesisVoice(language: $0.languageCode)
                utterText.rate = 0.5
                synthesizer.speak(utterText)
            }
    }
    
    func binding(for item: WordModel) -> Binding<Bool> {
        Binding(
            get: {
                checkedWords.contains(item)
            },
            set: { isSelected in
                if isSelected {
                    checkedWords.insert(item)
                } else {
                    checkedWords.remove(item)
                }
            }
        )
    }
}
