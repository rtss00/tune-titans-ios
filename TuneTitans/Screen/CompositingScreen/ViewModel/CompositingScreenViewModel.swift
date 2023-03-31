//
//  CompositingScreenViewModel.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import Foundation
import SwiftUI

enum ViewModelState {
    case loaded, loading, error

    static let base: ViewModelState = .loading
}

class ObservableViewModel: ObservableObject {
    @Published var state: ViewModelState = .base

    func load() {}
}

final class CompositingScreenViewModel: ObservableViewModel, CompositingViewModel {
    private let apiProvider: API
    private let model: CompositingScreenData
    private let configurationComplete: (SongConfig) -> Void

    var options: [CompositionOption] {
        guard let params = model.availableParams else {
            return []
        }

        let bpm = params.bpm.map { CompositionChoice(label: "\($0) BPM", value: $0) }
        let emotions = params.emotions.toCompositionChoices()
        let genres = params.genres.toCompositionChoices()
        let languages = params.languages.toCompositionChoices()
        let subjects = params.subjects.toCompositionChoices()

        return [
            .init(id: 0, title: "How fast should the song be?", choices: bpm),
            .init(id: 1, title: "Select an emotion that identifies your song", choices: emotions),
            .init(id: 2, title: "What genre does the song belong to?", choices: genres),
            .init(id: 3, title: "Which language is the song in", choices: languages),
            .init(id: 4, title: "Finally, select a subject for the song", choices: subjects)
        ]
    }

    init(
        model: CompositingScreenData = .shared,
        apiProvider: API = APIProvider(),
        configurationComplete: @escaping (SongConfig) -> Void
    ) {
        self.apiProvider = apiProvider
        self.model = model
        self.configurationComplete = configurationComplete

        super.init()

        load()
    }

    func notifyConfigurationComplete(choices: [Int: CompositionChoice]) {
        guard
            let bpm = choices[0]?.value as? Int,
            let emotion = choices[1]?.value as? String,
            let genre = choices[2]?.value as? String,
            let language = choices[3]?.value as? String,
            let subject = choices[4]?.value as? String
        else {
            return
        }

        let songConfig = SongConfig(bpm: bpm, emotion: emotion, language: language, genre: genre, subject: subject)
        configurationComplete(songConfig)
    }

    override func load() {
        // Detached task runs on a background thread
        Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }

            do {
                let params = try await self.apiProvider.getAvailableParams()
                await self.modelDidLoad(params)
            } catch {
                await self.handleError(error)
            }
        }
    }

    private func modelDidLoad(_ params: AvailableParams) async {
        await MainActor.run {
            model.setAvailableParams(params)
            state = .loaded
        }
    }

    private func handleError(_ error: Error) async {
        await MainActor.run {
            self.state = .error
        }
    }
}

extension Array<String> {
    func toCompositionChoices() -> [CompositionChoice] {
        map { CompositionChoice(label: $0.capitalized, value: $0) }
    }
}
