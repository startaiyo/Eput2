//
//  InputModal.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

import SwiftUI

struct InputModal: View {
    @Binding var tags: [TagModel]
    let onDismiss: (TagModel, WordModel) -> Void
    let onRegisterTag: () -> Void

    @State private var inputWord = ""
    @State private var selectedLanguage: Language = .japanese
    @State private var newTagText = ""
    @State private var tag: TagModel?
    
    private let wordAppService: any WordAppService = DefaultWordAppService()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Text("単語登録")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 16) // Add top padding to the navigation title
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Text("単語")
                        .font(.headline)
                    
                    TextField("インプットする単語を入力してください。", text: $inputWord)
                        .textFieldStyle(.roundedBorder)
                        .padding()

                }
                .padding()

                HStack {
                    Text("言語")
                        .font(.headline)
                    
                    Spacer()
                    
                    LanguagePicker(selectedLanguage: $selectedLanguage)
                }
                .padding()

                // Tags Section
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("タグ")
                            .font(.headline)

                        TagSelectView(
                            tags: $tags,
                            selected: $tag,
                            tagText: $newTagText,
                            registerTag: { tagText in
                                let tag = TagModel(
                                    id: UUID().uuidString,
                                    tagName: tagText
                                )
                                sendTag(tag)
                            }
                        )
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding()

                // Register Button
                Button("登録する") {
                    Task {
                        guard let tag else { return }
                        let word = WordDTO(
                            id: UUID().uuidString,
                            word: inputWord,
                            tagID: tag.id,
                            languageCode: selectedLanguage.code
                        )
                        try wordAppService.saveWordData(word) {
                            dismiss()
                            onDismiss(tag, word.toModel())
                        }
                    }
                }
                .disabled(!(!inputWord.isEmpty && tag != nil))
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding()
            }
            .background(Color(uiColor: .systemGray6)) // Light gray background color
            .cornerRadius(16) // Rounded corners for the modal
            .padding() // Add padding to the modal
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .padding(.trailing, 2)
                            
                            Text("Back")
                        }
                    }
                }
            }
            .navigationTitle("")
        }
    }
}

private extension InputModal {
    func sendTag(_ tag: TagModel?) {
        Task {
            guard let tag else { return }
            try wordAppService.saveTag(tag)
            onRegisterTag()
        }
    }
}
