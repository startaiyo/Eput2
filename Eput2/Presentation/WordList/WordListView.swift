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
    @State private var selected: Set<WordModel> = []
    let deleteWord: (WordModel) -> Void
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
                }
            }
            .background(Color(.systemGray6))
            
            Button("Read Text") {
                readText()
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }.background(Color(.systemGray6))
    }
    @Binding var itemList: [WordModel]

    func readText() {
        selected.forEach {
            let utterText = AVSpeechUtterance(string: $0.word)
            utterText.voice = AVSpeechSynthesisVoice(language: $0.lang)
            utterText.rate = 0.5
            synthesizer.speak(utterText)
        }
    }

    private func binding(for item: WordModel) -> Binding<Bool> {
        Binding(
            get: {
                selected.contains(item)
            },
            set: { isSelected in
                if isSelected {
                    selected.insert(item)
                } else {
                    selected.remove(item)
                }
            }
        )
    }
}
