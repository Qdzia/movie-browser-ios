//
//  UserDefaultsKey.swift
//  movie-browser
//
//  Created by Łukasz Kudzia on 19/05/2023.
//

import Foundation

enum UserDefaultsKey: String {
    case favoritesMovies
}

extension UserDefaults {
    func load(forKey key: UserDefaultsKey) -> Any? {
        return self.object(forKey: key.rawValue)
    }
    
    func save(_ value: Any, forKey key: UserDefaultsKey) {
        self.set(value, forKey: key.rawValue)
    }
}
