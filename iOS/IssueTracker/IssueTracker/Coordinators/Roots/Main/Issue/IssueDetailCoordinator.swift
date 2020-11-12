//
//  IssueDetailCoordinator.swift
//  IssueTracker
//
//  Created by Seungeon Kim on 2020/11/09.
//

import UIKit

class IssueDetailCoordinator: Coordinator {
    private enum StoryboardName: String {
        case IssueDetail, IssueBottomSheet, IssueEdit
    }
    private(set) var window: UIWindow
    private(set) var childCoordinators: [String : Coordinator] = [:]
    private weak var parent: UIViewController?
    
    private var issue: Issue
    
    init(window: UIWindow, parent: UIViewController, issue: Issue) {
        self.window = window
        self.parent = parent
        self.issue = issue
    }
    
    func start() {
        let storyBoard = UIStoryboard(name: StoryboardName.IssueDetail.rawValue, bundle: nil)
        let issueDeatailViewController = storyBoard.instantiateViewController(
            identifier: "IssueDetailViewController",
            creator: {
                coder in
                return IssueDetailViewController(coder: coder, delegate: self)
            })
        
        issueDeatailViewController.service = IssueDetailCacheService(issue: issue, delegate: issueDeatailViewController)
        
        let navigationController = parent as? UINavigationController
        issueDeatailViewController.title = "이슈 상세"
        navigationController?.pushViewController(issueDeatailViewController, animated: true)
    }
}

extension IssueDetailCoordinator: IssueDetailCoordinatorDelegate {
    func presentToAssigneeEdit(assignees: Assignees) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(assignees)
        
        presentToEdit(key: .assignee, data: data)
    }
    
    func presentToLabelEdit(labels: Labels) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(labels)
        
        presentToEdit(key: .label, data: data)
    }
    
    func presentToMilestoneEdit(milstones: Milestones) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(milstones)
        
        presentToEdit(key: .milestone, data: data)
    }
    
    private func presentToEdit(key: EditKey, data: Data) {
        let serive = IssueEditCacheService(issue: issue, delegate: self)
        let storyBoard = UIStoryboard(name: StoryboardName.IssueEdit.rawValue, bundle: nil)
        let issueEditViewController = storyBoard.instantiateViewController(
            identifier: "IssueEditViewController",
            creator: {
                coder in
                return IssueEditViewController(coder: coder, key: key, data: data, service: serive)
            })
        
        parent?.present(issueEditViewController, animated: true, completion: nil)
    }
}

extension IssueDetailCoordinator: IssueEditServiceDelegate {
    func didAssigneeLoaded(isSuccess: Bool) {
        NotificationCenter.default.post(name: .resumeIssueList, object: nil)
    }
    
    func didLabelsLoaded(isSuccess: Bool) {
        NotificationCenter.default.post(name: .resumeIssueList, object: nil)
    }
    
    func didMilestoneLoaded(isSuccess: Bool) {
        NotificationCenter.default.post(name: .resumeIssueList, object: nil)
    }
}

extension Notification.Name {
    static let resumeIssueList = Notification.Name(rawValue: "resumeIssueList")
}
