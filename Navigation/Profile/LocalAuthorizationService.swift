import Foundation

class LocalAuthorizationService {
    private let biometricIDAuth = BiometricIDAuth()
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, String?) -> Void) {
        
            biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                guard canEvaluate else {
                    authorizationFinished(false, canEvaluateError?.localizedDescription)
                    return
                }
                
                biometricIDAuth.evaluate { [weak self] (success, error) in
                    guard success else {
                        authorizationFinished(false, error?.localizedDescription)
                        return
                    }
                    
                    authorizationFinished(true, nil)
                }
            }
    }
}
