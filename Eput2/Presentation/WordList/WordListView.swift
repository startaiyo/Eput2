//
//  WordListView.swift
//  Eput2
//
//  Created by 土井星太朗 on 2024/03/30.
//

import SwiftUI
import AVFoundation

struct WordListView: View {
    @State var synthesizer = AVSpeechSynthesizer()
    @State private var selected: WordModel?
    let deleteWord: (WordModel) -> Void
    @Binding var checkedItems: Set<WordModel>
    @Binding var itemList: [WordModel]
    let onOrderChange: (_ newOrder: [WordModel]) -> Void
    let selectedTag: TagModel

    var body: some View {
        VStack {
            List(selection: $selected) {
                ForEach(itemList, id: \.self) { item in
                    WordCell(text: item.word,
                             checkBox: CheckBoxView(isChecked: self.binding(for: item)))
                        .listRowBackground(Color.white)
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteWord(item)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }.onMove { from, to in
                    itemList.move(fromOffsets: from,
                                  toOffset: to)
                    onOrderChange(itemList)
                }
            }
            .background(Color(.systemGray6))

            Button("テキスト読み上げ") {
                readText()
            }
            .disabled(checkedItems.isEmpty)
            .buttonStyle(.bordered)
            .tint(.red)
        }.background(Color(.systemGray6))
    }

    func readText() {
        checkedItems.filter { $0.tagID == selectedTag.id }.sorted { (index1, index2) in
            if let firstIndex = itemList.firstIndex(of: index1),
               let secondIndex = itemList.firstIndex(of: index2) {
                return firstIndex < secondIndex
            } else {
                return false
            }}.forEach {
            let utterText = AVSpeechUtterance(string: $0.word)
            utterText.voice = AVSpeechSynthesisVoice(language: $0.lang)
            utterText.rate = 0.5
            synthesizer.speak(utterText)
        }
    }

    private func binding(for item: WordModel) -> Binding<Bool> {
        Binding(
            get: {
                checkedItems.contains(item)
            },
            set: { isSelected in
                if isSelected {
                    checkedItems.insert(item)
                } else {
                    checkedItems.remove(item)
                }
            }
        )
    }
}
