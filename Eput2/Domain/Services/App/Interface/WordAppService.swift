//
//  WordAppService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

protocol WordAppService {
    func saveWordData(_ word: WordDTO, completionHandler: @escaping () -> Void) throws
    func saveWordsToUserDefaults(_ words: [WordDTO], for tagID: TagID)
    func getWordsFromUserDefaults(_ tagID: TagID) -> [WordModel]
    func deleteWord(_ word: WordDTO) throws
    func getWords(of tag: TagID) -> [WordModel]
    func saveTag(_ tag: TagModel) throws
    func getAllTags() -> [TagModel]
    func deleteTag(_ tag: TagDTO) throws
}
