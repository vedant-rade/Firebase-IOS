//
//  LoginVC.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailIdTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(identifier: "SignupVC") as? SignupVC {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        loginUser(email: emailIdTf.text ?? "", password: passwordTf.text ?? "")
        FBHelper.shared.loginUser(email: emailIdTf.text ?? "", password: passwordTf.text ?? "")
    }
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            // ✅ Login successful
            if let user = authResult?.user {
                print("User logged in: \(user.email ?? "no email")")
                
                self.openProfile()
            }
        }
    }
    
    func openProfile() {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        if let nextVC = storyboard.instantiateViewController(identifier: "ProfileVC") as? ProfileVC {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
