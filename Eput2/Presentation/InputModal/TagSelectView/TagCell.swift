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
                .foregroundColor(.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8) // Increase vertical padding for more spacing
                .cornerRadius(8) // Reduce corner radius for a more subtle appearance
                .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 1) // Reduce shadow intensity
                .frame(maxWidth: .infinity) // Expand cell to fill the width
                .overlay(
                    RoundedRectangle(cornerRadius: 8) // Add rounded rectangle overlay to create border
                        .stroke(Color.black.opacity(0.2), lineWidth: 1) // Set stroke color and width
                )

            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    TagCell()
}
