//
//  MatchRequests.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 2/20/19.
//

import Foundation

/*
 All match requests for Challonge
 */
extension ChallongeNetworking {
    /// Gets all the matches for a given TournamentId
    public func getMatchesForTournament(_ id: Int,
                                        completion: (([Match]) -> Void)? = nil,
                                        onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        guard let url = URL(string: "\(baseUrlString)/\(id)/\(Entity.matches).json") else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootMatches = try? self.jsonDecoder.decode([RootMatch].self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                let match = rootMatches.map { $0.match }
                completion?(match)
            }, onError: onError)
        }
    }
    
    /// Gets a match's information for given tournament Id and associated match Id
    public func getSingleMatchForTournament(_ tournamentId: Int,
                                            matchId: Int,
                                            completion: ((Match) -> Void)? = nil,
                                            onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        guard let url = URL(string: "\(baseUrlString)/\(tournamentId)/\(Entity.matches)/\(matchId).json") else {
            return
        }
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootMatch = try? self.jsonDecoder.decode(RootMatch.self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                completion?(rootMatch.match)
            }, onError: onError)
        }
    }
    
    /// Sets the winner for a match with the participants Id
    /// The score is set as "player1Score-player2Score"
    public func setWinnerForMatch(_ tournamentId: Int,
                                  matchId: Int,
                                  winnderId: Int,
                                  score: String?,
                                  completion: ((Match) -> Void)? = nil,
                                  onError: ((Error) -> Void)? = nil) {
        dataTask?.cancel()
        defer {
            dataTask?.resume()
        }
        
        guard let url = URL(string: "\(baseUrlString)/\(tournamentId)/\(Entity.matches)/\(matchId).json") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let updateMatch = UpdateMatch(winnerId: winnderId, scoresCsv: score)
        
        guard let data = try? jsonEncoder.encode(RootUpdateMatch(match: updateMatch)) else {
            return
        }
        request.httpBody = data
        dataTask = defaultSession.dataTask(with: request) { data, response, error in
            defer {
                self.dataTask = nil
            }
            self.parseDataTaskResult(data: data, response: response, error: error, completion: { data in
                guard let rootMatch = try? self.jsonDecoder.decode(RootMatch.self, from: data) else {
                    onError?(ChallongeError.decodeFail)
                    return
                }
                completion?(rootMatch.match)
            }, onError: onError)
        }
    }
}
