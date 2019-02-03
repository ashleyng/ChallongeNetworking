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
        case name, icon
        case mainId = "id"
        case tournamentId = "tournament_id"
        case groupPlayerIdsArray = "group_player_ids"
    }
    
    public struct Id {
        public let main: Int
        public let group: [Int]
        public let all: [Int]
    }
    
    private let mainId: Int
    public let name: String
    public let tournamentId: Int
    public let icon: String?
    private let groupPlayerIdsArray: [Int]
    public let id: Id
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        mainId = try values.decode(Int.self, forKey: .mainId)
        name = try values.decode(String.self, forKey: .name)
        tournamentId = try values.decode(Int.self, forKey: .tournamentId)
        icon = try values.decode(String.self, forKey: .tournamentId)
        groupPlayerIdsArray = try values.decode(Array.self, forKey: .groupPlayerIdsArray)
        var groupIdCopy = groupPlayerIdsArray
        groupIdCopy.append(mainId)
        id = Id(main: mainId, group: groupPlayerIdsArray, all: groupIdCopy)
    }
}


