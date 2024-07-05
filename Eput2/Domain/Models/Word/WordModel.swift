//
//  WordModel.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

struct WordModel: Hashable, Identifiable {
    let id: String
    let word: String
    let tagID: TagID
    let languageCode: String
}

extension WordModel {
    func toDTO() -> WordDTO {
        .init(
            id: id,
            word: word,
            tagID: tagID,
            languageCode: languageCode
        )
    }
}
