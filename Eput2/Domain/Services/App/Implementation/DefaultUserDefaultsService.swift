//
//  DefaultUserDefaultsService.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/21.
//

import Foundation

final class DefaultUserDefaultsService {
    private let userDefaults = UserDefaults.standard
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
}

extension DefaultUserDefaultsService: UserDefaultsService {
    func saveObjects<T: Codable>(_ values: [T],
                                 forKey key: String) throws {
        userDefaults.set(try jsonEncoder.encode(values),
                         forKey: key)
    }

    func getObjects<T: Codable>(forKey key: String) throws -> [T] {
        guard let data = userDefaults.object(forKey: key) as? Data else { return [] }
        let decodedData = try jsonDecoder.decode([T].self,
                                                 from: data)
        return decodedData
    }
}

