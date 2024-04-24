//
//  LangSelectView.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct LangSelectView: View {
    @Binding var selectedLang: String

    var body: some View {
        Picker("", 
               selection: $selectedLang) {
            Text("日本語").tag(Langs.Japanese.value)
            Text("English").tag(Langs.English.value)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

enum Langs {
    case Japanese
    case English

    var value: String {
        switch self {
            case .English:
                return "en-US"
            case .Japanese:
                return "ja-JP"
        }
    }
}
