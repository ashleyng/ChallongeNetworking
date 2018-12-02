//
//  Match.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 11/14/18.
//

import Foundation

public struct RootMatch: Codable {
    let match: Match
}

public struct Match: Codable {
    public enum State: String, Codable {
        case open
        case pending
        case complete
    }
    
    enum CodingKeys: String, CodingKey {
        case id, state
        case player1Id = "player1_id"
        case player2Id = "player2_id"
        case tournamentId = "tournament_id"
        case winnerId = "winner_id"
        case scoresCsv = "scores_csv"
        case suggestedPlayOrder = "suggested_play_order"
    }
    
    public let id: Int
    public let player1Id: Int?
    public let player2Id: Int?
    public let state: State
    public let tournamentId: Int
    public let winnerId: Int?
    public let scoresCsv: String?
    public let suggestedPlayOrder: Int
}
