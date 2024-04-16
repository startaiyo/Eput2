//
//  WordDTO.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

struct WordDTO: Equatable {
    let id: String
    let word: String
    let tagID: TagID
    let lang: String
}

// MARK: - Custom initializers
extension WordDTO {
    init(from object: WordObject) {
        id = object.id
        word = object.word
        tagID = object.tagID
        lang = object.lang
    }
}

// MARK: - Public functions
extension WordDTO {
    func toModel() -> WordModel {
        return .init(id: id,
                     word: word,
                     tagID: tagID,
                     lang: lang)
    }

    func toObject() -> WordObject {
        return WordObject(id: id,
                          word: word,
                          tagID: tagID,
                          lang: lang)
    }
}
