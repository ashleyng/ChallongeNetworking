//
//  ChallongeNetworking.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 11/14/18.
//

public class ChallongeNetworking {
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    let baseUrlString: String
    lazy var jsonDecoder = JSONDecoder()
    lazy var jsonEncoder = JSONEncoder()
    
    enum Entity: String {
        case tournaments
        case matches
        case participants
    }
    
    enum ChallongeError: Error {
        case decodeFail
        case unknown
        case fourOhFour
    }
    
    public init(username: String, apiKey: String) {
        self.baseUrlString = "https://\(username):\(apiKey)@api.challonge.com/v1/\(Entity.tournaments)"
    }
    
    /// Checkes if the saved credentials are correct
    /// and returns the status code from the server
    public func checkCredentials(completion: @escaping (Int?) -> Void) {
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

            if let urlResponse = response as? HTTPURLResponse {
                completion(urlResponse.statusCode)
                return
            }
            completion(nil)
        }
    }

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

    private func parseDataTaskResult(data: Data?,
                                     response: URLResponse?,
                                     error: Error?,
                                     completion: ((Data) -> Void)? = nil,
                                     onError: ((Error) -> Void)? = nil) {
        if let error = error {
            onError?(error)
        } else if let data = data,
            let response = response as? HTTPURLResponse {
            print("STATUS CODE: \(response.statusCode)")
            if (response.statusCode == 200) {
                completion?(data)
            } else if (response.statusCode == 404) {
                onError?(ChallongeError.fourOhFour)
            } else {
                print("OTHER EEERRROROR: \(response.statusCode)")
            }
        } else {
            onError?(ChallongeError.unknown)
        }
    }
}
