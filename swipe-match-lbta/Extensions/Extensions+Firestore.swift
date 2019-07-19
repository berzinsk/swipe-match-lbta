//
//  Extensions+Firestore.swift
//  swipe-match-lbta
//
//  Created by Kārlis Bērziņš on 19/07/2019.
//  Copyright © 2019 Karlis Berzins. All rights reserved.
//

import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        // TODO: Show error here
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
