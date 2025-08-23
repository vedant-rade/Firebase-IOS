//
//  ProjectCoordinator.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import UIKit

extension UIViewController {
    func openSignupVC() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(identifier: "SignupVC") as? SignupVC {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func openLoginVC() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
