//
//  Log.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

class Log {
    static func debug(_ message: String, function: String = #function, line: Int = #line) {
        print("🟣 \(function):\(line) \(message)")
    }
    
    static func error(_ message: String, function: String = #function, line: Int = #line) {
        print("‼️ \(function):\(line) \(message)")
    }
}
