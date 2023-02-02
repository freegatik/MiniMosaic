//
//  MiniAppListViewModel.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 22.01.2023.
//

import UIKit

enum MiniAppGridLayoutMode: Equatable {
    case compactRows
    case halfRows
    case fullRows

    var cellHeightFactor: CGFloat {
        switch self {
        case .compactRows:
            return 1.0 / 8.0
        case .halfRows:
            return 1.0 / 2.0
        case .fullRows:
            return 1.0
        }
    }

    var interactionEnabled: Bool {
        switch self {
        case .compactRows:
            return false
        case .halfRows, .fullRows:
            return true
        }
    }
}

final class MiniAppListViewModel {
    private let factory: MiniAppFactory
    private(set) var miniApps: [BaseMiniAppView] = []
    private(set) var layoutMode: MiniAppGridLayoutMode = .compactRows

    init(factory: MiniAppFactory) {
        self.factory = factory
    }

    func loadMiniApps(count: Int = 14) {
        miniApps = (0..<count).map { _ in factory.makeRandomMiniApp() }
    }

    func setLayoutMode(_ mode: MiniAppGridLayoutMode) {
        layoutMode = mode
    }

    var cellHeightFactor: CGFloat { layoutMode.cellHeightFactor }
    var interactionEnabled: Bool { layoutMode.interactionEnabled }
}
