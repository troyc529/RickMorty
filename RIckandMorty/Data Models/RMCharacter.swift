//
//  RMCharacter.swift
//  RIckandMorty
//
//  Created by Troy Carloni on 11/11/22.
//

import Foundation

struct RMCharacterResponse: Decodable {
    let results: [RMCharacter]
}

struct RMCharacter: Decodable, Identifiable {
    
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String?
    var gender: String
    var origin: Origin
    var location: Location
    var image: String
    var episode: [String]
    
    struct Origin: Decodable {
        var name: String
        var url: String
        
    }
    
    struct Location: Decodable {
        var name: String
        var url: String
        
    }
    
}

extension RMCharacter: RickMortyCharacter{
    func getNumEpisodes() -> Int {
        return self.episode.count
    }
    
    func isAlive() -> Bool {
        return self.status.lowercased() == "alive"
    }

    
    
}


protocol RickMortyCharacter{
    func getNumEpisodes() -> Int
    func isAlive() -> Bool
}

