//
//  CompositionOption.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation

struct CompositionOption: Identifiable {
    let id: Int
    let title: String
    let choices: [CompositionChoice]
}

struct CompositionChoice: Identifiable, Hashable {
    let label: String
    let value: AnyHashable

    var id: String {
        label
    }
}
