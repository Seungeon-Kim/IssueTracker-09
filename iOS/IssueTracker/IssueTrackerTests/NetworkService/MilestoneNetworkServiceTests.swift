//
//  MilestoneNetworkServiceTests.swift
//  IssueTrackerTests
//
//  Created by 현기엽 on 2020/11/05.
//

import XCTest
@testable import IssueTracker

class MilestoneNetworkServiceTests: XCTestCase {
    let asyncTimeout: TimeInterval = 5
    static let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAsImlhdCI6MTYwNDkzNDM2N30.ME-ENY-pPQmKVjpii2D65LMV1lV3FrwZuKq6hSheIAE"
    static var originalToken: String?
    
    override class func setUp() {
        super.setUp()
        
        // 기존 토큰이 있을 경우를 위한 백업
        originalToken = PersistenceManager.shared.load(forKey: .token)
        
        PersistenceManager.shared.save(testToken, forKey: .token)
    }
    
    override class func tearDown() {
        super.tearDown()
        
        // 복원
        if let token = originalToken {
            PersistenceManager.shared.save(token, forKey: .token)
        }
    }
    
    func testAddMilestone() throws {
        let expectTimer = expectation(description: "testAddMilestone")
        
        let milestone = Milestone(id: 0, title: "iOS-testAddMilestone", content: "testAddMilestone", deadline: "2020-11-07", isOpened: true, openCount: nil, totalCount: nil)
        MilestoneNetworkService().addMilestone(milestone) { result in
            switch result {
            case .success(_):
                expectTimer.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: asyncTimeout) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testFetchMilestones() throws {
        let expectTimer = expectation(description: "testFetchMilestones")
        
        MilestoneNetworkService().fetchMilestones { result in
            switch result {
            case .success(_):
                expectTimer.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: asyncTimeout) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
