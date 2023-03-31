//
//  CompositingScreen.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import Foundation
import SwiftUI

protocol CompositingViewModel: ObservableViewModel {
    var options: [CompositionOption] { get }

    func notifyConfigurationComplete(choices: [Int: CompositionChoice])
}

struct CompositingScreen<ViewModel: CompositingViewModel>: View {
    @State var currentId = 0
    @State var choices: [Int: CompositionChoice] = [:]
    @State var state: ViewModelState = .base
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        stateView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground(colors: [.pink, .yellow])
                    .ignoresSafeArea())
            .onReceive(viewModel.$state) { state in
                withAnimation {
                    self.state = state
                }
            }
    }

    @ViewBuilder var stateView: some View {
        if state == .loaded {
            loadedContent
                .transition(.opacity)
        }

        if state == .loading {
            loadingContent
                .scaleEffect(.scaling(.large))
                .transition(.opacity)
        }

        if state == .error {
            ErrorView {
                viewModel.load()
            }
            .padding(.spacing(.large))
        }
    }

    var loadingContent: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }

    var loadedContent: some View {
        GeometryReader { outerReader in
            ScrollViewReader { scrollReader in
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.options) { option in
                            CompositionConfigurationCell(
                                highlightedCellID: $currentId,
                                compositionOption: option
                            ) { choice in
                                choices[option.id] = choice
                                withAnimation(.easeInOut) {
                                    scroll(scrollReader, to: option.id + 1)
                                }
                            }
                            .id(option.id)
                            .blur(radius: option.id == currentId ? 0 : 10)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    scroll(scrollReader, to: option.id)
                                }
                            }
                        }
                    }
                    .padding(.vertical, outerReader.size.height / 2)
                }
                .onAppear {
                    scrollReader.scrollTo(currentId, anchor: .center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollDisabled(true)
            }
        }
    }

    private func scroll(_ scrollReader: ScrollViewProxy, to id: Int) {
        let scrollPossible = 0..<viewModel.options.count ~= id
        guard scrollPossible else {
            notifyConfigEndedAttempted()
            return
        }

        currentId = id
        scrollReader.scrollTo(id, anchor: .center)
    }

    private func notifyConfigEndedAttempted() {
        viewModel.notifyConfigurationComplete(choices: choices)
    }
}

struct CompositingScreen_Previews: PreviewProvider {
    final class ViewModel: ObservableViewModel, CompositingViewModel {
        var options: [CompositionOption] {
            let bpm = format(["100 BPM", "100 BPM", "100 BPM"])
            let emotions = format(["Joy", "Sadness", "Worthlessness"])
            let genres = format(["Rock", "Pop", "Salsa"])
            let languages = format(["English", "Spanish", "German"])
            let subjects = format(["Love", "Grief", "Dancing"])
            return [
                .init(id: 0, title: "How fast should the song be?", choices: bpm),
                .init(id: 1, title: "Select an emotion that identifies your song", choices: emotions),
                .init(id: 2, title: "What genre does the song belong to?", choices: genres),
                .init(id: 3, title: "Which language is the song in", choices: languages),
                .init(id: 4, title: "Finally, select a subject for the song", choices: subjects)
            ]
        }

        override init() {
            super.init()

            state = .loaded
        }

        func notifyConfigurationComplete(choices: [Int : CompositionChoice]) {}

        private func format(_ texts: [String]) -> [CompositionChoice] {
            texts.map { value in
                CompositionChoice(label: value, value: value)
            }
        }
    }

    static var previews: some View {
        CompositingScreen(viewModel: ViewModel())
    }
}
