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
        case tournamentId = "tournament_id"
    }
    
    public struct Id: Codable {
        enum CodingKeys: String, CodingKey {
            case main = "id"
            case group = "group_player_ids"
        }
        public let main: Int
        public let group: [Int]
        public var all: [Int] {
            var groupCopy = group
            groupCopy.append(main)
            return groupCopy
        }
    }
    
    public let name: String
    public let tournamentId: Int
    public let icon: String?
    /// a participant can have multiple Ids when the tournament
    /// is a multi-stage tournament (group stage and then bracket).
    /// `main` is their top level Id,
    /// `group` is the Ids the participant can have in the group stages.
    /// `all` is an array of all the participants Ids
    public let id: Id
    
    /// Custom decoder to properly setup the
    /// participant's multiple Ids.
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        tournamentId = try values.decode(Int.self, forKey: .tournamentId)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        
        let idValues = try decoder.container(keyedBy: Id.CodingKeys.self)
        let groupIds = try idValues.decode([Int].self, forKey: .group)
        let main = try idValues.decode(Int.self, forKey: .main)
        id = Id(main: main, group: groupIds)
    }
    
    public init(name: String, tournamentId: Int, icon: String?, id: Id) {
        self.name = name
        self.tournamentId = tournamentId
        self.icon = icon
        self.id = id
    }
}


