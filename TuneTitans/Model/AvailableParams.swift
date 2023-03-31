//
//  AvailableParams.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation

struct AvailableParams: Codable, DataConvertible {
    let bpm: [Int]
    let emotions: [String]
    let genres: [String]
    let languages: [String]
    let subjects: [String]
}
