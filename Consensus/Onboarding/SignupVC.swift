//
//  SignupVC.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupVC: UIViewController {

    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var emailIdTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupBtnAction(_ sender: UIButton) {
        signUp(name: nameTf.text ?? "", email: emailIdTf.text ?? "", password: passwordTf.text ?? "") { error in
            print(error)
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        
        // Step 1: Check if username exists
        db.collection("users").whereField("userName", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                // Username already taken
                let err = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Username already exists"])
                completion(err)
                return
            }
            
            // Step 2: If username is unique → create user
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let uid = authResult?.user.uid else { return }
                
                db.collection("users").document(uid).setData([
                    "userName": name,
                    "email": email,
                    "createdAt": Timestamp()
                ]) { error in
                    completion(error)
                }
                
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
