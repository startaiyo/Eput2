//
//  TagSelectView.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct TagSelectView: View {
    private let wordAppService = DefaultWordAppService()
    @State var showingNewTagField = false
    @Binding var tags: [TagModel]
    @Binding var selected: TagModel?
    @Binding var tagText: String
    let registerTag: (String) -> Void

    var body: some View {
        VStack {
            List(selection: $selected) {
                ForEach(tags, id: \.self) { item in
                    TagCell(tagName: item.tagName,
                            isSelected: selected == item)
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteTag(item)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                Button("+") {
                    showingNewTagField.toggle()
                }
            }
            .scrollContentBackground(.hidden)
            .background(.white)
            .listStyle(PlainListStyle())
            .alert("Enter new tag name",
                   isPresented: $showingNewTagField) {
                TextField("Enter new tag name",
                          text: $tagText)
                Button("OK",
                       action: {
                    registerTag(tagText)
                })
            }
        }
    }
}

extension TagSelectView {
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
