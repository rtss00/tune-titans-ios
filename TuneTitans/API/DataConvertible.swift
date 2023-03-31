//
//  DataConvertible.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation

enum EncodingError: Error {
    case dataConversionFailed
}

protocol DataConvertible {
    func toData() throws -> Data
}

extension Data: DataConvertible {
    func toData() throws -> Data {
        self
    }
}

extension String: DataConvertible {
    func toData() throws -> Data {
        guard let data = self.data(using: .utf8) else {
            throw EncodingError.dataConversionFailed
        }

        return data
    }
}

extension DataConvertible where Self: Encodable {
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}
