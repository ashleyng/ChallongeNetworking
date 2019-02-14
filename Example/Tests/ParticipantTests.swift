//
//  ParticipantTests.swift
//  ChallongeNetworking_Tests
//
//  Created by Ashley Ng on 2/13/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import ChallongeNetworking

class ParticipantTests: XCTestCase {

    var networking: ChallongeNetworking!
    let tournamentId = 1
    
    override func setUp() {
        networking = ChallongeNetworking(username: "MockUsername", apiKey: "MockAPIKey")
        stub(condition: isHost("api.challonge.com")) { _ in
            let stubPath = OHPathForFile("MultiParticipants-Feb-2019.json", type(of: self))
            return fixture(filePath: stubPath!, headers: nil)
        }
    }

    func testGetParticipantsForTournamentCount() {
        var actualParticipants: [Participant]!
        let expectation = self.expectation(description: "Fetch Participants")
        networking.getParticipantsForTournament(tournamentId, completion: { participants in
            actualParticipants = participants
            expectation.fulfill()
        })
        let expectedParticipants = setupNonGroupParticipants()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        
        XCTAssertEqual(actualParticipants.count, expectedParticipants.count)
    }
    
    func testGetParticipantsForTournamentVariables() {
        var actualParticipants: [Participant]!
        let expectation = self.expectation(description: "Fetch Participants")
        networking.getParticipantsForTournament(tournamentId, completion: { participants in
            actualParticipants = participants
            expectation.fulfill()
        })
        let expectedParticipants = setupNonGroupParticipants()
        
        waitForExpectations(timeout: Constants.stubTimout, handler: nil)
        
        XCTAssertEqual(actualParticipants[0].name, expectedParticipants[0].name)
        XCTAssertEqual(actualParticipants[0].id.group, expectedParticipants[0].id.group)

        XCTAssertEqual(actualParticipants[1].name, expectedParticipants[1].name)
        XCTAssertEqual(actualParticipants[1].id.group, expectedParticipants[1].id.group)

        XCTAssertEqual(actualParticipants[2].name, expectedParticipants[2].name)
        XCTAssertEqual(actualParticipants[2].id.group, expectedParticipants[2].id.group)
        
        XCTAssertEqual(actualParticipants[3].name, expectedParticipants[3].name)
        XCTAssertEqual(actualParticipants[3].id.group, expectedParticipants[3].id.group)
    }
    
    private func setupNonGroupParticipants() -> [Participant] {
        let p1 = Participant(name: "Annabell Zhang1234", tournamentId: 12345, icon: nil, id: Participant.Id(main: 76, group: [92]))
        let p2 = Participant(name: "Ronan Shepard", tournamentId: 12345, icon: nil, id: Participant.Id(main: 77, group: [93]))
        let p3 = Participant(name: "Norah Hewitt", tournamentId: 12345, icon: nil, id: Participant.Id(main: 78, group: [94]))
        let p4 = Participant(name: "Thea Summer", tournamentId: 12345, icon: nil, id: Participant.Id(main: 79, group: [96]))
        return [p1, p2, p3, p4]
    }
}
