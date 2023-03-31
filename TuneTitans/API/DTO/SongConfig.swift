//
//  SongConfig.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/28/23.
//

import Foundation

struct SongConfig: Codable, DataConvertible {
    let bpm: Int
    let emotion: String
    let language: String
    let genre: String
    let subject: String
}

extension SongConfig {
    static let testValue = SongConfig(
        bpm: 100,
        emotion: "sadness",
        language: "english",
        genre: "rock",
        subject: "grief")
}
