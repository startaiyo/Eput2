//
//  WordObject.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift

class WordObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var word: String
    @Persisted var tagID: String
    @Persisted var lang: String
}

// MARK: - Custom initializers
extension WordObject {
    convenience init(id: String,
                     word: String,
                     tagID: String,
                     lang: String) {
        self.init()
        self.id = id
        self.word = word
        self.tagID = tagID
        self.lang = lang
    }
}

// MARK: - Public functions
extension WordObject {
    func toDTO() -> WordDTO {
        return .init(from: self)
    }
}
