//
//  TagSelectView.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct TagSelectView: View {
    private let wordAppService: any WordAppService = DefaultWordAppService()
    @State var showingNewTagField = false
    @Binding var tags: [TagModel]
    @Binding var selectedTag: TagModel?
    @Binding var tagText: String
    let registerTag: (String) -> Void

    var body: some View {
        VStack {
            Spacer()

            List(selection: $selectedTag) {
                ForEach(tags) { tag in
                    TagCell(tagName: tag.tagName, isSelected: selectedTag == tag)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 8)
                        .onTapGesture {
                            selectedTag = tag
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                deleteTag(tag)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }

                // New Tag Button
                Button {
                    showingNewTagField.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("新規タグ")
                    }
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .alert(
                "新しいタグ名を入力",
                isPresented: $showingNewTagField
            ) {
                TextField("新しいタグ名を入力", text: $tagText)
                Button("OK") {
                    registerTag(tagText)
                }
            }

            Spacer()
        }
        .padding()
        .background(.white) // White background
        .cornerRadius(8) // Rounded corners
        .shadow(radius: 2)
    }
}

private extension TagSelectView {
    func loadTag() {
        tags = wordAppService.getAllTags()
    }

    func deleteTag(_ tag: TagModel) {
        Task {
            try wordAppService.deleteTag(tag.toDTO())
            tags.removeAll { $0 == tag }
        }
    }
}
