//
//  UpdateMatch.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 12/4/18.
//

import Foundation

public struct RootUpdateMatch: Codable {
    public let match: UpdateMatch
}

public struct UpdateMatch: Codable {
    
    enum CodingKeys: String, CodingKey {
        case winnerId = "winner_id"
        case scoresCsv = "scores_csv"
    }
    
    public let winnerId: Int
    public let scoresCsv: String?
    
    init(winnerId: Int, scoresCsv: String?) {
        self.winnerId = winnerId
        self.scoresCsv = scoresCsv
    }
}
