//
//  UserDefaultsService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/21.
//

import Foundation

protocol UserDefaultsService {
    func saveObjects<T: Codable>(_ values: [T],
                                 forKey key: String) throws
    func getObjects<T: Codable>(forKey key: String) throws -> [T]
}
