//
//  DefaultWordStorageService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

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
            realm.add(tagObject, update: .all)
        }
    }

    func saveWord(_ word: WordDTO, completionHandler: @escaping () -> Void) throws {
        let wordObject = word.toObject()
        try realm.safeWrite {
            realm.add(wordObject, update: .all)
            completionHandler()
        }
    }

    func deleteWord(_ word: WordDTO) throws {
        let wordToBeDelete = realm.objects(WordObject.self).where { $0.id == word.id }
        try realm.safeWrite {
            realm.delete(wordToBeDelete)
        }
    }

    func getTags() -> [TagDTO] {
        realm.objects(TagObject.self).map { $0.toDTO() }
    }

    func deleteTag(_ tag: TagDTO) throws {
        let tagToBeDelete = realm.objects(TagObject.self).where { $0.id == tag.id }
        try realm.safeWrite {
            realm.delete(tagToBeDelete)
        }
    }
}
