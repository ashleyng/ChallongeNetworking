//
//  TournamentRequests.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 2/20/19.
//

import Foundation

/*
 All tournament requests for Challonge
 */
extension ChallongeNetworking {

    /// Fetches all the tournaments for the given user
    public func getAllTournaments(completion: (([Tournament]) -> Void)? = nil,
                                  onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        guard let url = URL(string: baseUrlString + ".json") else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootTournaments = try? self.jsonDecoder.decode([RootTournament].self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                let tournaments = rootTournaments.map { $0.tournament }
                completion?(tournaments)
            }, onError: onError)
        }
    }
    
    /// Gets the tournament for a tournament Id.
    /// Default fetch does not include information on it's participants or matches.
    public func getTournament(_ id: String,
                              includeParticipants: Bool = false,
                              includeMatches: Bool = false,
                              completion: ((Tournament) -> Void)? = nil,
                              onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        let includeParticipantsInt = includeParticipants ? 1 : 0
        let includeMatchesInt = includeMatches ? 1 : 0
        guard var urlComponent = URLComponents(string: "\(baseUrlString)/\(id).json") else {
            return
        }
        urlComponent.query = "include_participants=\(includeParticipantsInt)&include_matches=\(includeMatchesInt)"
        guard let url = urlComponent.url else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootTournaments = try? self.jsonDecoder.decode(RootTournament.self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                completion?(rootTournaments.tournament)
            }, onError: onError)
        }
    }
}
