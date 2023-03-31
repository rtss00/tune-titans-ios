//
//  ErrorView.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/31/23.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let action: () -> Void

    var body: some View {
        VStack(spacing: .spacing(.large)) {
            Text("An error occurred while handling this request.")
                .font(.system(size: .font(.xxLarge), weight: .bold))
                .foregroundColor(.white)
            TTButton(text: "Try Again", action: action)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ErrorView(action: {})
        }
        .padding(.spacing(.medium))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(GradientBackground(colors: [.pink, .purple]))
        .ignoresSafeArea()
    }
}
