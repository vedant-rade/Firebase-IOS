//
//  FBHelper.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import FirebaseAuth
import FirebaseFirestore

final class FBHelper {
    static let shared = FBHelper()
    
    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            // ✅ Login successful
            if let user = authResult?.user {
                print("User logged in: \(user.email ?? "no email")")
                
//                self.openProfile()
            }
        }
    }
    
    func signUp(name: String, email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document(uid).setData([
                "userName": name,
                "email": email,
                "createdAt": Timestamp()
            ]) { error in
                completion(error)
            }
            
//            self.openProfile()
        }
    }
}
