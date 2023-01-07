import Foundation
import FirebaseCore
import FirebaseAuth

class CheckerService: CheckerServiceProtocol {
    func checkCredentials(login: String, password: String) -> Bool {
        var res: Bool = false
        Task {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password, completion: { authDataResult, error in
                
                print(authDataResult ?? nil)
                print(error ?? nil)
                if authDataResult?.user != nil {
                    let user = authDataResult!.user
                    res = true
                    print(res)
                }
            } )
        }
        print(res)
        return res
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        Task {
            
            FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password, completion: { authDataResult, error in
                
                print(authDataResult ?? nil)
                print(error ?? nil)
                if authDataResult?.user != nil {
                    let user = authDataResult!.user
                    completion()
                } else {
                    errorHandler()
                }
            } )
        }
    }
    
    func sugnUp(login: String, password: String) -> Bool {
        var res: Bool = false
        FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password, completion: {response, error in
            print(response ?? nil)
            print(error ?? nil)
            res = true
        })
        return res
    }
    
    func sugnUp(login: String, password: String, _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void {
        
        FirebaseAuth.Auth.auth().createUser(withEmail: login, password: password, completion: {response, error in
            print(response ?? nil)
            print(error ?? nil)
            if response?.user != nil {
                let user = response!.user
                completionHandler()
            } else {
                errorHandler()
            }
        })
    }
}
