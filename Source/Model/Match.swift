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
    
    public struct PreReqInformation: Codable {
        enum CodingKeys: String, CodingKey {
            case player1MatchId = "player1_prereq_match_id"
            case player2MatchId = "player2_prereq_match_id"
            case player1MatchIsLoser = "player1_is_prereq_match_loser"
            case player2MatchIsLoser = "player2_is_prereq_match_loser"
        }
        
        public let player1MatchId: Int?
        public let player2MatchId: Int?
        public let player1MatchIsLoser: Bool
        public let player2MatchIsLoser: Bool
    }
    
    enum CodingKeys: String, CodingKey {
        case id, state, round
        case player1Id = "player1_id"
        case player2Id = "player2_id"
        case tournamentId = "tournament_id"
        case winnerId = "winner_id"
        case scoresCsv = "scores_csv"
        case suggestedPlayOrder = "suggested_play_order"
        case player1Votes = "player1_votes"
        case player2Votes = "player2_votes"
        case groupId = "group_id"
        
    }
    
    public let id: Int
    public let player1Id: Int?
    public let player2Id: Int?
    public let state: State
    public let tournamentId: Int
    public let winnerId: Int?
    public let scoresCsv: String?
    public let suggestedPlayOrder: Int?
    public let player1Votes: Int?
    public let player2Votes: Int?
    public let groupId: Int?
    public let round: Int
    public let preReqInfo: PreReqInformation
    
    /// Creates a dictionary mapped from the participants
    /// main Id to their score
    public var scores: Dictionary<Int, String>? {
        guard let player1Id = player1Id, let player2Id = player2Id, let splitScore = scoresCsv?.split(separator: "-"), splitScore.count > 0 else {
            return nil
        }
        return [player1Id: String(splitScore[0]), player2Id: String(splitScore[1])]
    }
    
    public var playerOneScore: String? {
        guard let splitScore = scoresCsv?.split(separator: "-"), splitScore.count > 0 else {
            return nil
        }
        return String(splitScore[0])
    }
    
    public var playerTwoScore: String? {
        guard let splitScore = scoresCsv?.split(separator: "-"), splitScore.count > 0 else {
            return nil
        }
        return String(splitScore[1])
    }
    
    /// Creates a dictionary mapped from the participants
    /// main Id to the number of votes they received
    public var votes: Dictionary<Int, Int>? {
        guard let player1Id = player1Id, let player2Id = player2Id, let player1Votes = player1Votes, let player2Votes = player2Votes else {
            return nil
        }
        
        return [player1Id: player1Votes, player2Id: player2Votes]
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        player1Id = try values.decodeIfPresent(Int.self, forKey: .player1Id)
        player2Id = try values.decodeIfPresent(Int.self, forKey: .player2Id)
        state = try values.decode(State.self, forKey: .state)
        tournamentId = try values.decode(Int.self, forKey: .tournamentId)
        winnerId = try values.decodeIfPresent(Int.self, forKey: .winnerId)
        scoresCsv = try values.decodeIfPresent(String.self, forKey: .scoresCsv)
        suggestedPlayOrder = try values.decodeIfPresent(Int.self, forKey: .suggestedPlayOrder)
        player1Votes = try values.decodeIfPresent(Int.self, forKey: .player1Votes)
        player2Votes = try values.decodeIfPresent(Int.self, forKey: .player2Votes)
        groupId = try values.decodeIfPresent(Int.self, forKey: .groupId)
        round = try values.decode(Int.self, forKey: .round)
        
        let preReqValues = try decoder.container(keyedBy: PreReqInformation.CodingKeys.self)
        let preReqPlayer1Match = try preReqValues.decodeIfPresent(Int.self, forKey: .player1MatchId)
        let preReqPlayer2Match = try preReqValues.decodeIfPresent(Int.self, forKey: .player2MatchId)
        let preReqPlayer1IsLoser = try preReqValues.decode(Bool.self, forKey: .player1MatchIsLoser)
        let preReqPlayer2IsLoser = try preReqValues.decode(Bool.self, forKey: .player2MatchIsLoser)
        
        preReqInfo = PreReqInformation(player1MatchId: preReqPlayer1Match, player2MatchId: preReqPlayer2Match, player1MatchIsLoser: preReqPlayer1IsLoser, player2MatchIsLoser: preReqPlayer2IsLoser)
    }
    
    public init(id: Int,
                player1Id: Int?,
                player2Id: Int?,
                state: State,
                tournamentId: Int,
                winnerId: Int?,
                scoresCsv: String?,
                suggestedPlayOrder: Int?,
                player1Votes: Int?,
                player2Votes: Int?,
                groupId: Int?,
                round: Int,
                preReqInfo: PreReqInformation) {
        self.id = id
        self.player1Id = player1Id
        self.player2Id = player2Id
        self.state = state
        self.tournamentId = tournamentId
        self.winnerId = winnerId
        self.scoresCsv = scoresCsv
        self.suggestedPlayOrder = suggestedPlayOrder
        self.player1Votes = player1Votes
        self.player2Votes = player2Votes
        self.groupId = groupId
        self.round = round
        self.preReqInfo = preReqInfo
    }
}
