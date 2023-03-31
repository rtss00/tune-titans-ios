//
//  ContentView.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var songConfig: SongConfig?

    var body: some View {
        if let songConfig {
            let viewModel = ReviewScreenViewModel(songConfig: songConfig) {
                set(config: nil)
            }
            ReviewScreen(viewModel: viewModel)
        } else {
            let viewModel = CompositingScreenViewModel { config in
                set(config: config)
            }
            CompositingScreen(viewModel: viewModel)
        }
    }

    private func set(config: SongConfig?) {
        withAnimation(.spring()) {
            self.songConfig = config
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
