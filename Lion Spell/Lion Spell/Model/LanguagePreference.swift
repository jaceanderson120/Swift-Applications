//
//  LanguagePreference.swift
//  Lion Spell
//
//  Created by Jace Anderson on 9/14/24.
//

import Foundation

enum LanguagePreference: String, CaseIterable, Identifiable {
    case english = "English"
    case french = "French"
    var id: RawValue{rawValue}
}
