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
        case pending // hasn't started yet
        case complete
        case underway // currently live
        case awaiting_review // waiting for tournament to be finalized
        case group_stages_underway

        public var readableStatus: String {
            switch self {
            case .pending:
                return "Not Started"
            case .complete:
                return "Completed"
            case .underway, .group_stages_underway:
                return "Live"
            case .awaiting_review:
                return "Needs Review"
            }
        }
    }
    
    public enum TournamentType: String, Codable {
        case singleElimination = "single elimination"
        case doubleElimination = "double elimination"
        case roundRobin = "round robin"
        case swiss
        case freeForAll = "free for all"
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
    
    public init(dateCreated: String,
                description: String,
                gameId: Int?,
                id: Int,
                name: String,
                participantsCount: Int,
                state: State,
                tournamentType: TournamentType,
                updatedAt: String,
                url: URL,
                liveImageUrl: URL) {
        self.dateCreated = dateCreated
        self.description = description
        self.gameId = gameId
        self.id = id
        self.name = name
        self.participantsCount = participantsCount
        self.state = state
        self.tournamentType = tournamentType
        self.updatedAt = updatedAt
        self.url = url
        self.liveImageUrl = liveImageUrl
    }
}
