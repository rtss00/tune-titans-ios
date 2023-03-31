//
//  API.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/28/23.
//

import Foundation

enum NetworkError: Error {
    case invalidEndpoint
    case invalidResponse
    case badRequest
    case serverError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol API {
    func getSong(config: SongConfig) async throws -> SongResponse
    func getAvailableParams() async throws -> AvailableParams
}

final class APIProvider: API, NetworkProvider {
    private let apiKey = ""
    private let host = ""

    private lazy var headers = [
        "Authorization": apiKey,
        "Content-Type": "application/json"
    ]

    func getSong(config: SongConfig) async throws -> SongResponse {
        let params = """
        {"language":"\(config.language)","genre":"\(config.genre)","bpm":\(config.bpm),"subject":"\(config.subject)","emotion":"\(config.emotion)"}
        """
        return try await execute(endpoint: "\(host)/song", method: .post, headers: headers, params: params)
    }

    func getAvailableParams() async throws -> AvailableParams {
        return try await execute(endpoint: "\(host)/song/choices", method: .get, headers: headers, params: Empty())
    }
}


