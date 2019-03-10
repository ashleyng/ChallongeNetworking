//
//  FetchAllTournamentsTests.swift
//  ChallongeNetworking_Tests
//
//  Created by Ashley Ng on 2/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ChallongeNetworking

class FetchAllTournamentsTests: XCTestCase {
    
    var networking: ChallongeNetworking!
    
    override func setUp() {
        networking = ChallongeNetworking(username: "MockUsername", apiKey: "MockAPIKey")
        stub(condition: isHost("api.challonge.com")) { _ in
            let stubPath = OHPathForFile("GetAllTournaments-Feb-2019.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
    }
    
    func testAllTournamentsCount() {
        var actualTournaments: [Tournament]!
        let expectation = self.expectation(description: "Fetch Tournaments")
        networking.getAllTournaments(completion: { tournament in
            actualTournaments = tournament
            expectation.fulfill()
        })
        let expectedTournaments = setupTournaments()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        XCTAssertEqual(actualTournaments.count, expectedTournaments.count)
    }
    
    func testAllTournamentsVariables() {
        var actualTournaments: [Tournament]!
        let expectation = self.expectation(description: "Fetch Tournaments")
        networking.getAllTournaments(completion: { tournaments in
            actualTournaments = tournaments
            expectation.fulfill()
        })
        let expectedTournament = setupTournaments()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        
        XCTAssertEqual(actualTournaments[0].id, expectedTournament[0].id)
        XCTAssertEqual(actualTournaments[0].name, expectedTournament[0].name)
        XCTAssertEqual(actualTournaments[0].participantsCount, expectedTournament[0].participantsCount)
        XCTAssertEqual(actualTournaments[0].state, expectedTournament[0].state)
        
        XCTAssertEqual(actualTournaments[1].id, expectedTournament[1].id)
        XCTAssertEqual(actualTournaments[1].name, expectedTournament[1].name)
        XCTAssertEqual(actualTournaments[1].participantsCount, expectedTournament[1].participantsCount)
        XCTAssertEqual(actualTournaments[1].state, expectedTournament[1].state)
        
        XCTAssertEqual(actualTournaments[2].id, expectedTournament[2].id)
        XCTAssertEqual(actualTournaments[2].name, expectedTournament[2].name)
        XCTAssertEqual(actualTournaments[2].participantsCount, expectedTournament[2].participantsCount)
        XCTAssertEqual(actualTournaments[2].state, expectedTournament[2].state)
    }
    
    func testReadableTournamentStatus() {
        var actualTournaments: [Tournament]!
        let expectation = self.expectation(description: "Fetch Tournaments")
        networking.getAllTournaments(completion: { tournaments in
            actualTournaments = tournaments
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        
        XCTAssertEqual(actualTournaments[0].state.readableStatus, "Live")
        XCTAssertEqual(actualTournaments[1].state.readableStatus, "Live")
        XCTAssertEqual(actualTournaments[2].state.readableStatus, "Needs Review")
    }
    
    private func setupTournaments() -> [Tournament] {
        let tournament1 = Tournament(dateCreated: "2018-12-27T21:32:12.009-06:00", description: "", gameId: nil, id: 12345, name: "Saturday Night Mario Kart", participantsCount: 25, state: .underway, tournamentType: .doubleElimination, updatedAt: "2019-02-03T18:09:26.461-06:00", url: URL(string: "https://challonge.com/12345")!, liveImageUrl: URL(string: "https://challonge.com/12345.svg")!)
        let tournament2 = Tournament(dateCreated: "2019-02-03T15:44:23.156-08:00", description: "", gameId: nil, id: 56789, name: "Rec League Basketball", participantsCount: 32, state: .group_stages_underway, tournamentType: .singleElimination, updatedAt: "2019-02-03T16:09:03.695-08:00", url: URL(string: "https://challonge.com/abcd1234")!, liveImageUrl: URL(string: "https://challonge.com/abcd1234/bracket.svg")!)
        let tournament3 = Tournament(dateCreated: "2019-02-02T01:44:57.884-06:00", description: "", gameId: nil, id: 45678, name: "Round Robin", participantsCount: 16, state: .awaiting_review, tournamentType: .roundRobin, updatedAt: "2019-02-03T16:09:03.695-08:00", url: URL(string: "https://challonge.com/abcd1234")!, liveImageUrl: URL(string: "https://challonge.com/abcd1234/bracket.svg")!)
        return [tournament1, tournament2, tournament3]
    }
}
