//
//  WordDTO.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

struct WordDTO: Equatable, Codable {
    let id: String
    let word: String
    let tagID: TagID
    let languageCode: String
}

// MARK: - Custom initializers

extension WordDTO {
    init(from object: WordObject) {
        id = object.id
        word = object.word
        tagID = object.tagID
        languageCode = object.languageCode
    }
}

// MARK: - Public functions

extension WordDTO {
    func toModel() -> WordModel {
        .init(
            id: id,
            word: word,
            tagID: tagID,
            languageCode: languageCode
        )
    }

    func toObject() -> WordObject {
        WordObject(
            id: id,
            word: word,
            tagID: tagID,
            languageCode: languageCode
        )
    }
}
