//
//  TagModel.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

typealias TagID = String

struct TagModel: Hashable {
    let id: TagID
    let tagName: String
}
