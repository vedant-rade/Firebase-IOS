//
//  FBHelper.swift
//  Consensus
//
//  Created by apple on 23/08/25.
//

import FirebaseAuth
import FirebaseFirestore

enum FirebaseError: String, Error {
    case unknown = "Unknown Login Error"
    case userNameAlreadyExist = "Username already exist"
    case userIdNotFOund = "User ID not found"
    
}

final class FBHelper {
    static let shared = FBHelper()
    
    func loginUser(
        email: String,
        password: String,
        _ completion: @escaping (Result<User, FirebaseError>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { authResult, error in
            if let error = error {
                debugPrint(error)
                completion(.failure(.unknown))   // Failure case
                return
            }
            
            if let user = authResult?.user {
                completion(.success(user))    // Success case
            } else {
                completion(.failure(.unknown))
            }
        }
    }
    
    func signUp(
        name: String,
        email: String,
        password: String,
        _ completion: @escaping (Result<String, FirebaseError>) -> Void
    ) {
        let db = Firestore.firestore()
        
        // Step 1: Check if username exists
        db.collection("users").whereField("userName", isEqualTo: name).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.unknown))
                return
            }
            
            if let snapshot = snapshot, !snapshot.documents.isEmpty {
                completion(.failure(.userNameAlreadyExist))
                return
            }
            
            // Step 2: If username is unique → create user
            Auth.auth().createUser(withEmail: email,
                                   password: password) { authResult, error in
                if let error = error {
                    completion(.failure(.unknown))
                    return
                }
                
                guard let uid = authResult?.user.uid else {
                    completion(.failure(.userIdNotFOund))
                    return
                }
                
                db.collection("users").document(uid).setData([
                    "userName": name,
                    "email": email,
                    "createdAt": Timestamp()
                ]) { error in
                    if let error = error {
                        completion(.failure(.unknown))
                    } else {
                        completion(.success(uid)) // success with user id
                    }
                }
            }
        }
    }
}
