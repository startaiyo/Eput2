//
//  CheckBoxView.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/16.
//

import SwiftUI

struct CheckBoxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            Image(systemName: isChecked ? "checkmark.square" : "square")
        }
        .buttonStyle(.plain)
    }
}
