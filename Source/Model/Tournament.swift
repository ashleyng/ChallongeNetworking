//
//  Tournament.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 11/14/18.
//

import Foundation

struct RootTournament: Codable {
    let tournament: Tournament
}

public struct Tournament: Codable {
    enum State: String, Codable {
        case all
        case pending
        case inProgress
        case ended
        case underway
    }
    
    enum TournamentType: String, Codable {
        case singleElimination = "single elimination"
        case doubleElimination = "double elimination"
        case roundRobin = "round robin"
        case swiss
    }
    
    enum CodingKeys: String, CodingKey {
        case dateCreated = "created_at"
        case description, id, name, state
        case gameId = "game_id"
        case participantsCount = "participants_count"
        case tournamentType = "tournament_type"
        case updatedAt = "updated_at"
        case url = "full_challonge_url"
        case liveImageUrl = "live_image_url"
    }
    
    let dateCreated: String
    let description: String
    let gameId: Int?
    let id: Int
    let name: String
    let participantsCount: Int
    let state: State
    let tournamentType: TournamentType
    let updatedAt: String
    let url: URL
    let liveImageUrl: URL
}
