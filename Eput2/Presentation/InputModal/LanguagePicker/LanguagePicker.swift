//
//  LanguagePicker.swift
//  Eput2
//
//  Created by Shotaro Doi on 2024/04/03.
//

import SwiftUI

struct LanguagePicker: View {
    @Binding var selectedLanguage: Language

    var body: some View {
        Picker("言語選択", selection: $selectedLanguage) {
            ForEach(Language.allCases) { language in
                Text(language.text)
                    .tag(language)
            }
        }
        .pickerStyle(.segmented)
    }
}

enum Language: Identifiable, CaseIterable {
    case japanese
    case english
    
    var id: String { code }

    var text: String {
        switch self {
        case .japanese: "日本語"
        case .english: "English"
        }
    }
    
    var code: String {
        switch self {
        case .japanese: "ja-JP"
        case .english: "en-US"
        }
    }
}
