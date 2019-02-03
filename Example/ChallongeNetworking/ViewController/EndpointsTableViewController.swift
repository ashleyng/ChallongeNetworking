//
//  EndpointsTableViewController.swift
//  ChallongeNetworking_Example
//
//  Created by Ashley Ng on 11/14/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import ChallongeNetworking

class EndpointsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    enum Endpoint: String {
        case getAllTournaments = "Get All Tournaments"
        case getTournament = "Get Single Tournament"
        case getParticipants = "Get Participants for Tournament"
        case getMatches = "Get Matches for Tournament"
        case getMatch = "Get Match for Tournament"
        case putMatchScore = "Put Match Score For Tournament"
    }
    
    let endpoints:[Endpoint] = [
        .getAllTournaments,
        .getTournament,
        .getParticipants,
        .getMatches,
        .getMatch,
        .putMatchScore
    ]
    
    let networking: ChallongeNetworking

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    init(username: String, apiKey: String) {
        self.networking = ChallongeNetworking(username: username, apiKey: apiKey)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.loadingIndicator.isHidden = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endpoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = endpoints[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let endpoint = endpoints[indexPath.row]
        let encoder = JSONEncoder()
        defer {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.isHidden = true
        }
        
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        
        switch endpoint {
        case .getAllTournaments:
            networking.getAllTournaments(completion: { tournaments in
                guard let encodedData = try? encoder.encode(tournaments),
                    let stringValue = String(data: encodedData, encoding: .utf8) else {
                        return
                }
                DispatchQueue.main.async {
                    let vc = JSONViewController(encodedEntityString: stringValue)
                    self.present(vc, animated: true, completion: nil)
                }
            }, onError: { [weak self] error in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    let alertVC = self.createAlert(title: "ERROR", message: "\(error.localizedDescription)")
                    self.present(alertVC, animated: true, completion: nil)
                }
            })
        case .getTournament:
            let alert = createAlertControllerWithTextField(title: nil, message: "Fetch tournament with ID") { id, _ in
                self.networking.getTournament(id, completion: { tournament in
                    guard let encodedData = try? encoder.encode(tournament),
                        let stringValue = String(data: encodedData, encoding: .utf8) else {
                            return
                    }
                    DispatchQueue.main.async {
                        let vc = JSONViewController(encodedEntityString: stringValue)
                        self.present(vc, animated: true, completion: nil)
                    }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        let alertVC = self.createAlert(title: "ERROR", message: "\(error.localizedDescription)")
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
            }
            self.present(alert, animated: true, completion: nil)
        case .getParticipants:
            let alert = createAlertControllerWithTextField(title: nil, message: "Fetch participants for tournament") { id, _ in
                self.networking.getParticipantsForTournament(Int(id)!, completion: { participants in
                    guard let encodedData = try? encoder.encode(participants),
                        let stringValue = String(data: encodedData, encoding: .utf8) else {
                            return
                    }
                    DispatchQueue.main.async {
                        let vc = JSONViewController(encodedEntityString: stringValue)
                        self.present(vc, animated: true, completion: nil)
                    }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        let alertVC = self.createAlert(title: "ERROR", message: "\(error.localizedDescription)")
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
            }
            self.present(alert, animated: true, completion: nil)
        case .getMatches:
            let alert = createAlertControllerWithTextField(title: nil, message: "Fetch matches for tournament") { id, _ in
                self.networking.getMatchesForTournament(Int(id)!, completion: { matches in
                    guard let encodedData = try? encoder.encode(matches),
                        let stringValue = String(data: encodedData, encoding: .utf8) else {
                            return
                    }
                    DispatchQueue.main.async {
                        let vc = JSONViewController(encodedEntityString: stringValue)
                        self.present(vc, animated: true, completion: nil)
                    }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        let alertVC = self.createAlert(title: "ERROR", message: "\(error.localizedDescription)")
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
            }
            self.present(alert, animated: true, completion: nil)
        case .getMatch:
            let alert = createAlertControllerWithTextField(title: nil, message: "Fetch match for tournament", addSecondEntityId: true) { id, secondId in
                guard let stringSecondId = secondId, let secondId = Int(stringSecondId), let id = Int(id) else {
                    return
                }
                self.networking.getSingleMatchForTournament(id, matchId: secondId, completion: { match in
                    guard let encodedData = try? encoder.encode(match),
                        let stringValue = String(data: encodedData, encoding: .utf8) else {
                            return
                    }
                    DispatchQueue.main.async {
                        let vc = JSONViewController(encodedEntityString: stringValue)
                        self.present(vc, animated: true, completion: nil)
                    }
                }, onError: { [weak self] error in
                    guard let `self` = self else { return }
                    DispatchQueue.main.async {
                        let alertVC = self.createAlert(title: "ERROR", message: "\(error.localizedDescription)")
                        self.present(alertVC, animated: true, completion: nil)
                    }
                })
            }
            self.present(alert, animated: true, completion: nil)
        case .putMatchScore:
            break
        }
    }
    
    private func createAlert(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
    
    private func createAlertControllerWithTextField(title: String?, message: String?, addSecondEntityId: Bool = false, completion: @escaping (String, String?) -> Void) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter Tournament Id"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let textFields = alert?.textFields else {
                return
            }
            guard let textField = textFields[0].text else {
                return
            }
            if textFields.count > 1, let secondTextField = textFields[1].text {
                completion(textField, secondTextField)
                return
            }
            completion(textField, nil)
        }))
        if addSecondEntityId {
            alert.addTextField { textField in
                textField.placeholder = "Enter 2nd Entity Id"
            }
        }
        
        return alert
    }
}
