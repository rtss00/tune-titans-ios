//
//  ReviewScreen.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/29/23.
//

import SwiftUI
import WrappingHStack

protocol ReviewViewModel: ObservableViewModel {
    var song: Song? { get }

    func onGoBackTapped()
}

struct ReviewScreen<ViewModel: ReviewViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    @State var state: ViewModelState = .base
    @State var showCredits = false

    var body: some View {
        stateView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GradientBackground(colors: [.pink, .purple])
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
                .transition(.opacity)
                .scaleEffect(.scaling(.large))
        }

        if state == .error {
            ErrorView {
                viewModel.load()
            }
            .padding(.spacing(.large))
        }
    }

    @ViewBuilder private var loadedContent: some View {
        if let song = viewModel.song {
            ScrollView {
                VStack(alignment: .leading, spacing: .spacing(.large)) {
                    HStack {
                        Image("icon-chevron-left")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35)
                            .rotationEffect(Angle(degrees: 180))
                            .foregroundColor(.white)
                            .onTapGesture {
                                viewModel.onGoBackTapped()
                            }
                        Text(song.title)
                            .titleStyle()
                    }

                    Text("Parameters")
                        .subHeadingStyle()

                    ParametersList(song: song)

                    Text("Lyrics")
                        .subHeadingStyle()

                    ForEach(song.paragraphs) { paragraph in
                        self.paragraph(for: paragraph)
                    }

                    TTButton(text: "How was this song made?") {
                        showCredits = true
                    }
                    .padding(.top, .spacing(.xxxLarge))
                }
                .padding(.spacing(.medium))
            }
            .sheet(isPresented: $showCredits) {
                ScrollView {
                    VStack(alignment: .leading, spacing: .spacing(.medium)) {
                        Text("This song was written using a language generator called GPT. We asked the model the following prompt:")
                            .font(.system(size: .font(.medium), weight: .bold))
                        Text(song.request)
                            .font(.system(size: .font(.small), weight: .bold))
                            .foregroundColor(.gray)
                        Text("And this was the model's answer:")
                            .font(.system(size: .font(.medium), weight: .bold))
                        Text(song.response)
                            .font(.system(size: .font(.small), weight: .bold))
                            .foregroundColor(.gray)
                    }
                    .padding(.spacing(.medium))
                }
            }
        }
    }

    private var loadingContent: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
    }

    @ViewBuilder private func paragraph(for paragraph: SongParagraph) -> some View {
        VStack(alignment: .leading, spacing: .spacing(.xxxSmall)) {
            Text(paragraph.title)
                .font(.system(size: .font(.medium), weight: .medium))
                .foregroundColor(.white.opacity(0.8))
            ForEach(paragraph.phrases) { phrase in
                self.phrase(for: phrase)
            }
        }
    }

    @ViewBuilder private func phrase(for phrase: SongPhrase) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(phrase.chords.joined(separator: " "))
                .font(.system(size: .font(.medium), weight: .light))
                .foregroundColor(.white.opacity(0.5))
            Text(phrase.text)
                .font(.system(size: .font(.xxLarge), weight: .bold))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.leading)
        }
    }
}

extension Text {
    func titleStyle() -> some View {
        self
            .font(.system(size: .font(.xxxxLarge), weight: .bold))
            .foregroundColor(.white.opacity(0.9))
    }

    func subHeadingStyle() -> some View {
        self
            .font(.system(size: .font(.xxxLarge), weight: .bold))
            .foregroundColor(.white.opacity(0.9))
            .padding(.top, .spacing(.medium))
    }
}

struct ReviewScreen_Previews: PreviewProvider {
    final class ViewModel: ObservableViewModel, ReviewViewModel {
        let song: Song? = .testValue

        override init() {
            super.init()

            state = .loaded
        }

        func onGoBackTapped() {}
    }

    static var previews: some View {
        let viewModel = ViewModel()
        return ReviewScreen(viewModel: viewModel)
    }
}
