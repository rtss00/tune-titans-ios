//
//  TTButton.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/31/23.
//

import SwiftUI

struct TTButton: View {
    let text: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: .font(.xxxLarge), weight: .bold))
                .padding(.spacing(.small))
                .foregroundColor(.white.opacity(0.9))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(TTButtonStyle())
    }
}

struct TTButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let opacity = configuration.isPressed ? 0.5 : 0.3
        return configuration.label
            .background(.white.opacity(opacity))
            .smoothCornerRadius(.radius(.large))
    }
}

struct TTButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TTButton(text: "How was this song made", action: {})
        }
        .padding(.spacing(.medium))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GradientBackground(colors: [.pink, .purple]))
        .ignoresSafeArea()
    }
}
