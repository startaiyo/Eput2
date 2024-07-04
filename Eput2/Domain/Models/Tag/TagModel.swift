//
//  TagModel.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

typealias TagID = String

struct TagModel: Hashable, Identifiable {
    let id: TagID
    let tagName: String
}

extension TagModel {
    func toDTO() -> TagDTO {
        .init(
            id: id,
            tagName: tagName
        )
    }
}
