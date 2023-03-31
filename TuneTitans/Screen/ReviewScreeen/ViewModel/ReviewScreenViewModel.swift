//
//  ReviewScreenViewModel.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation

final class ReviewScreenViewModel: ObservableViewModel, ReviewViewModel {
    let songConfig: SongConfig
    private let restartConfig: () -> Void
    private let apiProvider: API

    private var songResponse: SongResponse?

    var song: Song? {
        songResponse?.song
    }

    init(
        apiProvider: API = APIProvider(),
        songConfig: SongConfig,
        restartConfig: @escaping () -> Void
    ) {
        self.songConfig = songConfig
        self.restartConfig = restartConfig
        self.apiProvider = apiProvider

        super.init()

        load()
    }

    func onGoBackTapped() {
        restartConfig()
    }

    override func load() {
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }

            do {
                let response = try await self.apiProvider.getSong(config: self.songConfig)
                await self.songDidLoad(response)
            } catch {
                await self.handleError(error)
            }
        }
    }

    private func songDidLoad(_ songResponse: SongResponse) async {
        await MainActor.run {
            self.songResponse = songResponse
            state = .loaded
        }
    }

    private func handleError(_ error: Error) async {
        await MainActor.run {
            state = .error
        }
    }
}
