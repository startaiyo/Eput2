//
//  TagCell.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct TagCell: View {
    let tagName: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(tagName)
                .foregroundStyle(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8) // Increase vertical padding for more spacing
                .cornerRadius(8) // Reduce corner radius for a more subtle appearance
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1) // Reduce shadow intensity
                .frame(maxWidth: .infinity) // Expand cell to fill the width
                .overlay(
                    RoundedRectangle(cornerRadius: 8) // Add rounded rectangle overlay to create border
                        .stroke(.black.opacity(0.2), lineWidth: 1) // Set stroke color and width
                )

            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    TagCell(tagName: "", isSelected: false)
}
