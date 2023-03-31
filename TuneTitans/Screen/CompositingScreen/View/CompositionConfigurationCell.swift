//
//  CompositionConfigurationCell.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import Foundation
import SwiftUI
import WrappingHStack

struct CompositionConfigurationCell: View {
    /// Used to know if this cell is highlighted, and remove interaction with inner buttons if not
    @Binding var highlightedCellID: Int
    let compositionOption: CompositionOption
    let attributeSelected: (CompositionChoice) -> Void

    @State var choice: String?

    var body: some View {
        VStack(spacing: .spacing(.large)) {
            Text(compositionOption.title)
                .font(.system(size: .font(.xxxLarge)))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            WrappingHStack {
                ForEach(compositionOption.choices, id: \.self) { compositionChoice in
                    AttributeCell(text: compositionChoice.label, choice: $choice) {
                        withAnimation(.spring(blendDuration: 0.05)) {
                            choice = compositionChoice.label
                        }
                        attributeSelected(compositionChoice)
                    }
                }
            }
            .disabled(highlightedCellID != compositionOption.id)
        }
        .padding(.spacing(.xLarge))
        .background(
            Color.white
                .opacity(0.3)
                .blur(radius: 100)
        )
        .smoothCornerRadius(.radius(.xLarge))
        .padding(.spacing(.xLarge))
    }
}

struct CompositionConfigurationCell_Previews: PreviewProvider {
    static var previews: some View {
        @State var highlight = 1

        let option = CompositionOption(
            id: 1,
            title: "Choose a genre for your song",
            choices: [
                CompositionChoice(label: "Rock", value: "rock"),
                CompositionChoice(label: "Ballad", value: "ballad"),
                CompositionChoice(label: "Metal", value: "metal"),
                CompositionChoice(label: "Alternative", value: "alternative"),
                CompositionChoice(label: "Indie", value: "indie")
            ]
        )

        return VStack {
            CompositionConfigurationCell(
                highlightedCellID: $highlight,
                compositionOption: option,
                attributeSelected: { _ in })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            GradientBackground(colors: [.pink, .yellow])
                .ignoresSafeArea()
        )
    }
}

extension View {
    func smoothCornerRadius(_ radius: CGFloat) -> some View {
        self.clipShape(
            RoundedRectangle(cornerRadius: radius, style: .continuous))
    }
}
