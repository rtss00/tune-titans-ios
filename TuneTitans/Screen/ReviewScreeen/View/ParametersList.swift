//
//  ParametersList.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/30/23.
//

import SwiftUI
import WrappingHStack

struct ParametersList: View {
    @State var song: Song

    var body: some View {
        WrappingHStack(alignment: .leading) {
            cell(for: song.formattedBPM)
            cell(for: song.genre)
            cell(for: song.emotion)
            cell(for: song.subject)
            cell(for: song.language)
        }
    }

    @ViewBuilder private func cell(for text: String) -> some View {
        Text(text.capitalized)
            .font(.system(size: .font(.large), weight: .bold))
            .foregroundColor(.white.opacity(0.8))
            .padding(.spacing(.small))
            .background(.white.opacity(0.3))
            .smoothCornerRadius(.radius(.xLarge))
    }
}

struct ParametersList_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ParametersList(song: .testValue)
        }
        .padding(.spacing(.medium))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GradientBackground(colors: [.pink, .purple]))
        .ignoresSafeArea()
    }
}
