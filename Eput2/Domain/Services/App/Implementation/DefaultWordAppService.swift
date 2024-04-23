//
//  DefaultWordAppService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

final class DefaultWordAppService {
    private let storageService: WordStorageService
    private let userDefaultsService: UserDefaultsService

    init(storageService: WordStorageService = DefaultWordStorageService(),
         userDefaultsService: UserDefaultsService = DefaultUserDefaultsService()) {
        self.storageService = storageService
        self.userDefaultsService = userDefaultsService
    }
}

extension DefaultWordAppService: WordAppService {
    func saveWordData(_ word: WordDTO,
                      completionHandler: @escaping () -> Void) throws {
        try storageService.saveWord(word) {
            completionHandler()
        }
    }
    
    func deleteWord(_ word: WordDTO) throws {
        try storageService.deleteWord(word)
    }
    
    func getWords(of tag: TagID) -> [WordModel] {
        return storageService.getWords(of: tag).map { $0.toModel() }
    }

    func saveTag(_ tag: TagModel) throws {
        try storageService.saveTag(tag.toDTO())
    }

    func getAllTags() -> [TagModel] {
        return storageService.getTags().map { $0.toModel() }
    }

    func saveWordsToUserDefaults(_ words: [WordDTO],
                                 for tagID: TagID) {
        do {
            try userDefaultsService.saveObjects(words,
                                                forKey: tagID)
        } catch {
            print(error)
        }
    }

    func getWordsFromUserDefaults(_ tagID: TagID) -> [WordModel] {
        do {
            let words = try userDefaultsService.getObjects(forKey: tagID) as [WordDTO]
            return words.map { $0.toModel() }
        } catch {
            print(error)
            return []
        }
    }
}
