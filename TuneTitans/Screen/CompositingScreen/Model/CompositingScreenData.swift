//
//  CompositingScreenData.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation

final class CompositingScreenData {
    static let shared = CompositingScreenData()

    var paramsConfiguration: [String: String] = [:]
    private(set) var availableParams: AvailableParams?

    func setAvailableParams(_ params: AvailableParams) {
        guard availableParams == nil else { return }

        availableParams = params
    }
}
