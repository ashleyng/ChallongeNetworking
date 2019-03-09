//
//  FetchMatchesForTournamentTests.swift
//  ChallongeNetworking_Tests
//
//  Created by Ashley Ng on 2/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ChallongeNetworking

class FetchMatchesForTournamentTests: XCTestCase {
    var networking: ChallongeNetworking!
    let tournamentId = 1
    
    override func setUp() {
        networking = ChallongeNetworking(username: "MockUsername", apiKey: "MockAPIKey")
        stub(condition: isHost("api.challonge.com")) { _ in
            let stubPath = OHPathForFile("Matches-Feb-2019.json", type(of: self))
            return fixture(filePath: stubPath!, headers: nil)
        }
    }
    
    func testMatchesCount() {
        var actualMatches: [Match]!
        let expectation = self.expectation(description: "Fetch Matches")
        networking.getMatchesForTournament(tournamentId, completion: { matches in
            actualMatches = matches
            expectation.fulfill()
        })
        let expectedMatches = setupExpectedMatches()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        XCTAssertEqual(actualMatches.count, expectedMatches.count)
    }
    
    func testCompletedMatchesVariables() {
        var actualMatch: Match!
        let expectation = self.expectation(description: "Fetch Matches")
        networking.getMatchesForTournament(tournamentId, completion: { matches in
            actualMatch = matches[0]
            expectation.fulfill()
        })
        let expectedMatch = setupExpectedMatches()[0].match
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        XCTAssertEqual(actualMatch.id, expectedMatch.id)
        XCTAssertEqual(actualMatch.player1Id, expectedMatch.player1Id)
        XCTAssertEqual(actualMatch.player2Id, expectedMatch.player2Id)
        XCTAssertEqual(actualMatch.state, expectedMatch.state)
        XCTAssertEqual(actualMatch.winnerId, expectedMatch.winnerId)
        XCTAssertEqual(actualMatch.scoresCsv, expectedMatch.scoresCsv)
    }
    
    func testIncompletedMatchesVariables() {
        var actualMatch: Match!
        let expectation = self.expectation(description: "Fetch Matches")
        networking.getMatchesForTournament(tournamentId, completion: { matches in
            actualMatch = matches[4]
            expectation.fulfill()
        })
        let expectedMatch = setupExpectedMatches()[4].match
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        XCTAssertEqual(actualMatch.id, expectedMatch.id)
        XCTAssertEqual(actualMatch.player1Id, expectedMatch.player1Id)
        XCTAssertEqual(actualMatch.player2Id, expectedMatch.player2Id)
        XCTAssertEqual(actualMatch.state, expectedMatch.state)
        XCTAssertEqual(actualMatch.winnerId, expectedMatch.winnerId)
        XCTAssertEqual(actualMatch.scoresCsv, expectedMatch.scoresCsv)
    }
    
    private func setupExpectedMatches() -> [RootMatch] {
        let preReq = Match.PreReqInformation(player1MatchId: nil, player2MatchId: nil, player1MatchIsLoser: false, player2MatchIsLoser: false)
        let match1 = Match(id: 1, player1Id: 34, player2Id: 35, state: .complete, tournamentId: 12345, winnerId: 34, scoresCsv: "5-3", suggestedPlayOrder: 1, player1Votes: nil, player2Votes: nil, groupId: nil, round: 1, preReqInfo: preReq)
        let match2 = Match(id: 2, player1Id: 86, player2Id: 43, state: .complete, tournamentId: 12345, winnerId: 43, scoresCsv: "1-5", suggestedPlayOrder: 3, player1Votes: nil, player2Votes: nil, groupId: nil, round: 1, preReqInfo: preReq)
        let match3 = Match(id: 3, player1Id: 90, player2Id: 39, state: .complete, tournamentId: 12345, winnerId: 39, scoresCsv: "2-5", suggestedPlayOrder: 5, player1Votes: nil, player2Votes: nil, groupId: nil, round: 1, preReqInfo: preReq)
        let match4 = Match(id: 4, player1Id: 33, player2Id: 36, state: .open, tournamentId: 12345, winnerId: nil, scoresCsv: "", suggestedPlayOrder: 6, player1Votes: nil, player2Votes: nil, groupId: nil, round: 1, preReqInfo: preReq)
        let match5 = Match(id: 5, player1Id: 87, player2Id: 42, state: .open, tournamentId: 12345, winnerId: nil, scoresCsv: "", suggestedPlayOrder: 7, player1Votes: nil, player2Votes: nil, groupId: nil, round: 1, preReqInfo: preReq)
        
        return [RootMatch(match: match1), RootMatch(match: match2), RootMatch(match: match3), RootMatch(match: match4), RootMatch(match: match5)]
    }

}
