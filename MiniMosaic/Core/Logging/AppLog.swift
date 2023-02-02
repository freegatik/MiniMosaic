//
//  AppLog.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 12.01.2023.
//

import OSLog

enum AppLog {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "MiniMosaic"

    private static let network = Logger(subsystem: subsystem, category: "network")

    static func networkError(_ message: String, error: Error? = nil) {
        if let error {
            network.error("\(message, privacy: .public): \(String(describing: error), privacy: .public)")
        } else {
            network.error("\(message, privacy: .public)")
        }
    }
}
