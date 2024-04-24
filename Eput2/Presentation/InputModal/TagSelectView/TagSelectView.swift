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
            Spacer()

            List(selection: $selected) {
                ForEach(tags, id: \.self) { item in
                    TagCell(tagName: item.tagName,
                            isSelected: selected == item)
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .padding(.vertical, 8) // Add vertical padding to create space between cells
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteTag(item)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }

                // New Tag Button
                Button(action: {
                    showingNewTagField.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
                        Text("New Tag")
                    }
                }
                .listRowSeparator(.hidden)
            }
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

            Spacer()
        }
        .padding()
        .background(Color.white) // White background
        .cornerRadius(8) // Rounded corners
        .shadow(radius: 2)
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
