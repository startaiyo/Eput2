//
//  RealmStorage.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift

struct RealmConstants {
    static let lastDBVersion: UInt64 = 1
}

final class RealmStorage {
    // MARK: Properties
    private var realm: Realm {
        guard let realm = try? Realm(configuration: RealmStorage.config()) else {
            fatalError("Could not create Realm")
        }
        realm.refresh()
        return realm
    }
}

extension RealmStorage {
    static func config() -> Realm.Configuration {
        var config = Realm.Configuration()
        config.schemaVersion = RealmConstants.lastDBVersion
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < RealmConstants.lastDBVersion {}
        }
        return config
    }
}
