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
        case player1Votes = "player1_votes"
        case player2Votes = "player2_votes"
    }
    
    public let id: Int
    public let player1Id: Int?
    public let player2Id: Int?
    public let state: State
    public let tournamentId: Int
    public let winnerId: Int?
    public let scoresCsv: String?
    public let suggestedPlayOrder: Int
    public let player1Votes: Int?
    public let player2Votes: Int?
    
    public var scores: Dictionary<Int, String>? {
        guard let player1Id = player1Id, let player2Id = player2Id, let splitScore = scoresCsv?.split(separator: "-"), splitScore.count > 0 else {
            return nil
        }
        return [player1Id: String(splitScore[0]), player2Id: String(splitScore[1])]
    }
    
    public var votes: Dictionary<Int, Int>? {
        guard let player1Id = player1Id, let player2Id = player2Id, let player1Votes = player1Votes, let player2Votes = player2Votes else {
            return nil
        }
        
        return [player1Id: player1Votes, player2Id: player2Votes]
    }
}
