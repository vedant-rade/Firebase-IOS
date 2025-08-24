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
        FBHelper.shared.signUp(name: nameTf.text ?? "", email: emailIdTf.text ?? "", password: passwordTf.text ?? "") { result in
            switch result {
            case .success(_):
                self.openProfile()
            case .failure(let error):
                print(error.rawValue)
            }
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
    
}
