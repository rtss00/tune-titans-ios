//
//  Constant.swift
//  TuneTitans
//
//  Created by Renzo Tissoni on 3/23/23.
//

import Foundation

enum FontSize: CGFloat {
    case xSmall = 10
    case small = 12
    case medium = 16
    case large = 18
    case xLarge = 20
    case xxLarge = 22
    case xxxLarge = 26
    case xxxxLarge = 40
}

enum RadiusSize: CGFloat {
    case xSmall = 2
    case small = 4
    case medium = 8
    case large = 12
    case xLarge = 16
    case xxLarge = 20
}

enum SpacingSize: CGFloat {
    case xxxSmall = 2
    case xxSmall = 4
    case xSmall = 8
    case small = 12
    case medium = 16
    case large = 20
    case xLarge = 24
    case xxLarge = 28
    case xxxLarge = 32
}

enum Scaling: CGFloat {
    case large = 2
}

extension CGFloat {
    static func font(_ size: FontSize) -> CGFloat {
        size.rawValue
    }

    static func radius(_ size: RadiusSize) -> CGFloat {
        size.rawValue
    }

    static func spacing(_ size: SpacingSize) -> CGFloat {
        size.rawValue
    }

    static func scaling(_ size: Scaling) -> CGFloat {
        size.rawValue
    }
}
