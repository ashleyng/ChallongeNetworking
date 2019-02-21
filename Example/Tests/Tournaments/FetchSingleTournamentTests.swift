//
//  FetchSingleTournamentTests.swift
//  ChallongeNetworking_Example
//
//  Created by Ashley Ng on 2/20/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ChallongeNetworking

class FetchSingleTournamentTests: XCTestCase {
    
    var networking: ChallongeNetworking!
    
    override func setUp() {
        networking = ChallongeNetworking(username: "MockUsername", apiKey: "MockAPIKey")
        stub(condition: isHost("api.challonge.com")) { _ in
            let stubPath = OHPathForFile("GetSingleTournament-Feb-2019.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }

    func testAllTournamentsVariables() {
        var actualTournament: Tournament!
        let expectation = self.expectation(description: "Fetch Tournament")
        networking.getTournament("12345", completion: { tournaments in
            actualTournament = tournaments
            expectation.fulfill()
        })
        let expectedTournament = setupTournament()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        
        XCTAssertEqual(actualTournament.id, expectedTournament.id)
        XCTAssertEqual(actualTournament.name, expectedTournament.name)
        XCTAssertEqual(actualTournament.participantsCount, expectedTournament.participantsCount)
        XCTAssertEqual(actualTournament.state, expectedTournament.state)
    }
    
    private func setupTournament() -> Tournament {
        return Tournament(dateCreated: "2018-12-27T21:32:12.009-06:00", description: "", gameId: nil, id: 12345, name: "Saturday Night Mario Kart", participantsCount: 25, state: .underway, tournamentType: .doubleElimination, updatedAt: "2019-02-03T18:09:26.461-06:00", url: URL(string: "https://challonge.com/12345")!, liveImageUrl: URL(string: "https://challonge.com/12345.svg")!)
    }
}
