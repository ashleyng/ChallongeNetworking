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
    enum State: String, Codable {
        case open
        case pending
    }
    
    enum CodingKeys: String, CodingKey {
        case id, state
        case player1Id = "player1_id"
        case player2Id = "player2_id"
        case tournamentId = "tournament_id"
        case winnerId = "winner_id"
        case scoresCsv = "scores_csv"
    }
    
    let id: Int
    let player1Id: Int?
    let player2Id: Int?
    let state: State
    let tournamentId: Int
    let winnerId: Int?
    let scoresCsv: String?
}
