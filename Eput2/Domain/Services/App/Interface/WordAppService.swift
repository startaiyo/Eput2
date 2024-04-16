//
//  WordAppService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

protocol WordAppService {
    func saveWordData(_ word: WordDTO) throws
    func deleteWord(_ word: WordDTO) throws
    func getWords(of tag: TagID) -> [WordModel]
    func saveTag(_ tag: TagModel) throws
    func getAllTags() -> [TagModel]
}
