//
//  ProfileVC.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import FirebaseAuth

import UIKit

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        logoutUser()
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            if let nextVC = storyboard.instantiateViewController(identifier: "LoginVC") as? LoginVC {
                navigationController?.pushViewController(nextVC, animated: true)
            }
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}
