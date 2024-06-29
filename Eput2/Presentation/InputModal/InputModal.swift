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
    var onDismiss: (TagModel, WordModel) -> Void
    var onRegisterTag: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Input")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 16) // Add top padding to the navigation title
                    .frame(maxWidth: .infinity, 
                           alignment: .center)

                HStack {
                    Text("Input")
                        .font(.headline)
                    TextField("Enter text", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                }.padding()

                HStack {
                    Text("Language")
                        .font(.headline)
                    Spacer()
                    LangSelectView(selectedLang: $lang)
                }
                .padding()

                // Tags Section
                VStack {
                    Spacer()
                    HStack(alignment: .center,
                           spacing: 8) {
                        Text("Tags")
                            .font(.headline)

                        TagSelectView(tags: $tags,
                                      selected: $tag,
                                      tagText: $newTagText,
                                      registerTag: { tagText in
                            let tag = TagModel(id: UUID().uuidString,
                                               tagName: tagText)
                            sendTag(tag)
                        })
                        .padding()
                    }
                    Spacer()
                }.padding()

                // Register Button
                Button("Register") {
                    Task {
                        guard let tag else { return }
                        let word = WordDTO(id: UUID().uuidString,
                                           word: inputText,
                                           tagID: tag.id,
                                           lang: lang)
                        try wordAppService.saveWordData(word) {
                            dismiss()
                            onDismiss(tag,
                                      word.toModel())
                        }
                    }
                }
                .disabled(!(!inputText.isEmpty && tag != nil))
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding()
            }
            .background(Color(UIColor.systemGray6)) // Light gray background color
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

extension InputModal {
    func sendTag(_ tag: TagModel?) {
        Task {
            guard let tag else { return }
            try wordAppService.saveTag(tag)
            onRegisterTag()
        }
    }
}
