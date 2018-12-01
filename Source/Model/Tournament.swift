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
    public enum State: String, Codable {
        case all
        case pending
        case inProgress
        case ended
        case underway
    }
    
    public enum TournamentType: String, Codable {
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
    
    public let dateCreated: String
    public let description: String
    public let gameId: Int?
    public let id: Int
    public let name: String
    public let participantsCount: Int
    public let state: State
    public let tournamentType: TournamentType
    public let updatedAt: String
    public let url: URL
    public let liveImageUrl: URL
}
