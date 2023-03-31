//
//  NetworkProvider.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/28/23.
//

import Foundation

protocol NetworkProvider {
    func execute<T>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String],
        params: DataConvertible
    ) async throws -> T where T: Decodable
}

extension NetworkProvider {
    func execute<T>(
        endpoint: String,
        method: HTTPMethod,
        headers: [String: String],
        params: DataConvertible
    ) async throws -> T where T: Decodable {
        guard let url = URL(string: endpoint) else { throw NetworkError.invalidEndpoint }

        var request = URLRequest(url: url)
        if method != .get {
            request.httpBody = try params.toData()
        }
        request.httpMethod = method.rawValue
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = 90

        let session = URLSession.shared
        let (data, response) = try await session.data(for: request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        print(String(data: data, encoding: .utf8))

        switch response.statusCode {
        case 200..<300:
            return try decodeData(data)
        case 300..<400:
            throw NetworkError.invalidResponse
        case 400..<500:
            throw NetworkError.badRequest
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
    }

    private func decodeData<T: Decodable>(_ data: Data) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
