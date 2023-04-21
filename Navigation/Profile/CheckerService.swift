import Foundation
import FirebaseCore
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    func checkCredentials(login: String, password: String, _ completion: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        Task {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password, completion: { authDataResult, error in
                if let firebaseUser = authDataResult?.user {
                    let user = User(userId: firebaseUser.uid, fullName: firebaseUser.displayName ?? "", avatarImageSrc: "", status: "")
                    completion(user)
                } else {
                    errorHandler()
                }
            } )
        }
    }
    
    func sugnUp(login: String, password: String, _ completionHandler: @escaping (User) -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password, completion: {response, error in
            if let firebaseUser = response?.user  {
                let user = User(userId: firebaseUser.uid, fullName: firebaseUser.displayName ?? "", avatarImageSrc: "", status: "")
                completionHandler(user)
            } else {
                errorHandler()
            }
        })
    }

    func logout() -> Void {
        try? FirebaseAuth.Auth.auth().signOut()
    }
}
