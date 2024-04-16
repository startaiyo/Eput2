//
//  Realm+.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/02.
//

import RealmSwift

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
