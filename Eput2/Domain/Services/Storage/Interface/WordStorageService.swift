//
//  WordStorageService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

protocol WordStorageService {
    func getWords(of tagID: TagID) -> [WordDTO]
    func saveTag(_ tag: TagDTO) throws
    func saveWord(_ word: WordDTO,
                  completionHandler: @escaping () -> Void) throws
    func deleteWord(_ word: WordDTO) throws
    func getTags() -> [TagDTO]
    func deleteTag(_ tag: TagDTO) throws
}
