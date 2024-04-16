//
//  DefaultWordAppService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

final class DefaultWordAppService {
    private let storageService: WordStorageService

    init(storageService: WordStorageService = DefaultWordStorageService()) {
        self.storageService = storageService
    }
}

extension DefaultWordAppService: WordAppService {
    func saveWordData(_ word: WordDTO) throws {
        try storageService.saveWord(word)
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
}
