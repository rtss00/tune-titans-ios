//
//  GradientBackground.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import SwiftUI

enum BackgroundState {
    case start, config, final

    var colors: [Color] {
        switch self {
        case .start:
            return [.pink, .yellow]
        case .config:
            return [.pink, .purple]
        case .final:
            return [.purple, .red]
        }
    }
}

struct GradientBackground: View {
    private var colors: [Color]
    @State var start = UnitPoint(x: 0, y: 0)
    @State var end = UnitPoint(x: 1, y: 1)

    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .onReceive(timer, perform: { _ in
                withAnimation(.easeInOut(duration: 6).repeatForever()) {
                    self.start = UnitPoint(x: 0, y: 0)
                    self.end = UnitPoint(x: 2, y: 1)
                }
            })
    }

    init(colors: [Color]) {
        self.colors = colors
    }
}

struct GradientBackground_Previews: PreviewProvider {
    static var previews: some View {
        let background = GradientBackground(colors: [.pink, .yellow])
        VStack {
            Button {
                print("tap")
            } label: {
                Text("Change State")
                    .foregroundColor(.white)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            background
                .ignoresSafeArea()
        )
    }
}
