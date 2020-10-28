//
//  SignCoordinator.swift
//  IssueTracker
//
//  Created by Seungeon Kim on 2020/10/27.
//

import UIKit

class SignCoordinator: Coordinator {
    private let storyboardName: String = "SignIn"
    private let window: UIWindow
    
    init(window: UIWindow? = UIWindow()) {
        if let window = window {
            self.window = window
        } else {
            self.window = UIWindow()
        }
    }
    
    func start() {
        window.makeKeyAndVisible()
        
        let storyBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyBoard.instantiateViewController(identifier: "SignViewController", creator: { coder in
            return SignViewController(coder: coder, delegate: self, request: GithubSignController.shared)
            })
//        let viewController = storyBoard.instantiateViewController(identifier: "SignViewController") as? SignViewController
        window.rootViewController = viewController
    }
}

extension SignCoordinator: NextCoordinatorDelegate {
    func navigateToPage() {
        print("move next page")
    }
}