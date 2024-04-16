//
//  TagCell.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct TagCell: View {
    var tagName = ""
    var isSelected = false
    var body: some View {
        HStack {
            Text(tagName)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
    }
}

#Preview {
    TagCell()
}
