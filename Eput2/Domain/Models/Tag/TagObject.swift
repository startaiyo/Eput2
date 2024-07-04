//
//  TagObject.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift

class TagObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var tagName: String
}

// MARK: - Custom initializers

extension TagObject {
    convenience init(
        id: String,
        tagName: String
    ) {
        self.init()
        self.id = id
        self.tagName = tagName
    }
}

// MARK: - Public functions

extension TagObject {
    func toDTO() -> TagDTO {
        .init(from: self)
    }
}
