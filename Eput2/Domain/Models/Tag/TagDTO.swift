//
//  TagDTO.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

struct TagDTO: Equatable {
    let id: TagID
    let tagName: String
}

// MARK: - Custom initializers

extension TagDTO {
    init(from object: TagObject) {
        id = object.id
        tagName = object.tagName
    }
}

// MARK: - Public functions

extension TagDTO {
    func toModel() -> TagModel {
        .init(
            id: id,
            tagName: tagName
        )
    }

    func toObject() -> TagObject {
        .init(
            id: id,
            tagName: tagName
        )
    }
}
