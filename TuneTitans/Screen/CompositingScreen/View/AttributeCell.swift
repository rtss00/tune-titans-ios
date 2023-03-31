//
//  AttributeCell.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import Foundation
import SwiftUI

struct AttributeCell: View {
    let text: String
    @Binding var choice: String?
    let action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
        }
        .buttonStyle(AttributeButtonStyle(text: text, choice: $choice))
    }
}

struct AttributeButtonStyle: ButtonStyle {
    let text: String
    @Binding var choice: String?

    func makeBody(configuration: Configuration) -> some View {
        let opacity: CGFloat = {
            if configuration.isPressed {
                return 0.2
            } else if choice == text {
                return 0.3
            } else {
                return 0.1
            }
        }()

        return configuration.label
            .font(.system(size: .font(.xLarge), weight: .bold))
            .foregroundColor(.white)
            .padding(.spacing(.small))
            .background(Color.white.opacity(opacity))
            .smoothCornerRadius(.radius(.large))
    }
}
