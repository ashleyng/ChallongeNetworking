//
//  Participant.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 11/14/18.
//

import Foundation

public struct RootParticipant: Codable {
    let participant: Participant
}

public struct Participant: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case tournamentId = "tournament_id"
    }
    
    let id: Int
    let name: String
    let tournamentId: Int
    
}

