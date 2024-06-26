//
//  WordModel.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

struct WordModel: Hashable {
    let id: String
    let word: String
    let tagID: TagID
    let lang: String
}

extension WordModel {
    func toDTO() -> WordDTO {
        return .init(id: id,
                     word: word,
                     tagID: tagID, 
                     lang: lang)
    }
}
