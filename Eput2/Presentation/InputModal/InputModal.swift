//
//  InputModal.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

import SwiftUI

struct InputModal: View {
    private let wordAppService = DefaultWordAppService()
    @State var inputText = ""
    @State var tag: TagModel?
    @State var lang: String = Langs.Japanese.value
    @State var newTagText = ""
    @Binding var tags: [TagModel]
    var onDismiss: (WordModel) -> Void
    var onRegisterTag: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("入力文")
                    TextField("文字を入力してください",
                              text: $inputText)
                    .textFieldStyle(.roundedBorder)

                }.padding()
                HStack {
                    Text("言語")
                    LangSelectView(selectedLang: $lang)
                }
                VStack {
                    Text("タグ")
                    TagSelectView(tags: $tags,
                                  selected: $tag,
                                  tagText: $newTagText,
                                  registerTag: { tagText in
                        let tag = TagModel(id: UUID().uuidString,
                                           tagName: tagText)
                        sendTag(tag)
                    })
                }
                .padding()
                Button("input登録") {
                    Task {
                        guard let tag else { return }
                        let word = WordDTO(id: UUID().uuidString,
                                           word: inputText,
                                           tagID: tag.id,
                                           lang: lang)
                        try wordAppService.saveWordData(word) {
                            dismiss()
                            onDismiss(word.toModel())
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {dismiss()}) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }
}

extension InputModal {
    func sendTag(_ tag: TagModel?) {
        Task {
            guard let tag else { return }
            try wordAppService.saveTag(tag)
            onRegisterTag()
        }
    }
}
