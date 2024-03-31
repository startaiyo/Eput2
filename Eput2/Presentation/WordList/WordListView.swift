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
    @State var itemList = [WordModel(id: "1", word: "ほげ", tagID: "1", lang: "ja-JP"),
                           WordModel(id: "2", word: "ふが", tagID: "2", lang: "ja-JP")]
    @State private var selected: Set<WordModel> = []
    var body: some View {
        VStack {
            List(selection: $selected) {
                ForEach(itemList, id: \.self) { item in
                    WordCell(text: item.word)
                }
            }
            .environment(\.editMode, .constant(.active))
            .onChange(of: selected) { _, _ in
                print(selected)
            }
            
            Button("Read Text") {
                readText()
            }
        }
    }

    func readText() {
        selected.forEach {
            let utterText = AVSpeechUtterance(string: $0.word)
            utterText.voice = AVSpeechSynthesisVoice(language: $0.lang)
            utterText.rate = 0.5
            synthesizer.speak(utterText)
        }
    }
}

#Preview {
    WordListView()
}
