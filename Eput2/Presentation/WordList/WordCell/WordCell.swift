//
//  WordCell.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/03/31.
//

import SwiftUI

struct WordCell: View {
    let text: String
    let checkBox: CheckBoxView

    var body: some View {
        HStack {
            checkBox
            Text(text)
        }
    }
}
