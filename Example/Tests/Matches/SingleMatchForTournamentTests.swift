//
//  SingleMatchForTournamentTests.swift
//  ChallongeNetworking_Tests
//
//  Created by Ashley Ng on 2/20/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ChallongeNetworking

class SingleMatchForTournamentTests: XCTestCase {
    var networking: ChallongeNetworking!
    let tournamentId = 1
    
    override func setUp() {
        networking = ChallongeNetworking(username: "MockUsername", apiKey: "MockAPIKey")
        stub(condition: isHost("api.challonge.com")) { _ in
            let stubPath = OHPathForFile("SingleMatch-Feb-2019.json", type(of: self))
            return fixture(filePath: stubPath!, headers: nil)
        }
    }
    
    func testCompletedMatchesVariables() {
        var actualMatch: Match!
        let expectation = self.expectation(description: "Fetch Matches")
        networking.getSingleMatchForTournament(12345, matchId: 123, completion: { match in
            actualMatch = match
            expectation.fulfill()
        })
        let expectedMatch = setupExpectedMatch()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        XCTAssertEqual(actualMatch.id, expectedMatch.id)
        XCTAssertEqual(actualMatch.player1Id, expectedMatch.player1Id)
        XCTAssertEqual(actualMatch.player2Id, expectedMatch.player2Id)
        XCTAssertEqual(actualMatch.state, expectedMatch.state)
        XCTAssertEqual(actualMatch.winnerId, expectedMatch.winnerId)
        XCTAssertEqual(actualMatch.scoresCsv, expectedMatch.scoresCsv)
    }
    
    private func setupExpectedMatch() -> Match {
        return Match(id: 123, player1Id: 93, player2Id: 94, state: .complete, tournamentId: 12345, winnerId: 93, scoresCsv: "4-2", suggestedPlayOrder: nil, player1Votes: nil, player2Votes: nil, groupId: 406, round: 1)
    }

}
