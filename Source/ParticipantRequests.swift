//
//  ParticipantRequests.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 2/20/19.
//

import Foundation

/*
 All participant requests for Challonge
 */
extension ChallongeNetworking {
    /// Gets all the participants for a given TournamentId
    public func getParticipantsForTournament(_ id: Int,
                                             completion: (([Participant]) -> Void)? = nil,
                                             onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        guard let url = URL(string: "\(baseUrlString)/\(id)/\(Entity.participants).json") else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootParticipants = try? self.jsonDecoder.decode([RootParticipant].self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                let participant = rootParticipants.map { $0.participant }
                completion?(participant)
            }, onError: onError)
        }
    }
}
