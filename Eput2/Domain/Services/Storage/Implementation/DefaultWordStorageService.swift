//
//  DefaultWordStorageService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

import Foundation
import RealmSwift

final class DefaultWordStorageService {
    // MARK: Private properties
    private let configuration: Realm.Configuration
    private var realm: Realm {
        guard let realm = try? Realm(configuration: configuration) else {
            fatalError("Failed to initialize Realm.")
        }
        return realm
    }

    // MARK: Lifecycle functions
    init(configuration: Realm.Configuration = RealmStorage.config()) {
        self.configuration = configuration
    }
}

extension DefaultWordStorageService: WordStorageService {
    func getWords(of tagID: TagID) -> [WordDTO] {
        let words = realm.objects(WordObject.self).where { $0.tagID == tagID }
        return words.map { $0.toDTO() }
    }

    func saveTag(_ tag: TagDTO) throws {
        let tagObject = tag.toObject()
        try realm.safeWrite {
            realm.add(tagObject,
                      update: .all)
        }
    }

    func saveWord(_ word: WordDTO) throws {
        let wordObject = word.toObject()
        try realm.safeWrite {
            realm.add(wordObject,
                      update: .all)
        }
    }

    func deleteWord(_ word: WordDTO) throws {
        try realm.safeWrite {
            realm.delete(word.toObject())
        }
    }

    func getTags() -> [TagDTO] {
        return realm.objects(TagObject.self).map { $0.toDTO() }
    }
}
