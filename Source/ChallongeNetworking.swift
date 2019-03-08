//
//  ChallongeNetworking.swift
//  ChallongeNetworking
//
//  Created by Ashley Ng on 11/14/18.
//

/*
 Base class for Challonge Networking
 Individual requests can be found grouped by their entity type files
 */
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
        case otherStatusCode(Int)
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

    func parseDataTaskResult(data: Data?,
                                     response: URLResponse?,
                                     error: Error?,
                                     completion: ((Data) -> Void)? = nil,
                                     onError: ((Error) -> Void)? = nil) {
        if let error = error {
            onError?(error)
        } else if let data = data,
            let response = response as? HTTPURLResponse {
            if (response.statusCode == 200) {
                completion?(data)
            } else if (response.statusCode == 404) {
                onError?(ChallongeError.fourOhFour)
            } else {
                onError?(ChallongeError.otherStatusCode(response.statusCode))
            }
        } else {
            onError?(ChallongeError.unknown)
        }
    }
}
