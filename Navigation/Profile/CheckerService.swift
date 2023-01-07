import Foundation
import FirebaseCore
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    func checkCredentials(login: String, password: String) -> Bool {
        var res: Bool = false
        Task {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password, completion: { authDataResult, error in
                if authDataResult?.user != nil {
                    res = true
                }
            } )
        }
        return res
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        Task {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password, completion: { authDataResult, error in
                if authDataResult?.user != nil {
                    completion()
                } else {
                    errorHandler()
                }
            } )
        }
    }
    
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password, completion: {response, error in
            if response?.user != nil {
                completionHandler()
            } else {
                errorHandler()
            }
        })
    }
}
