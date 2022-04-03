import Foundation
class CredentialsCheckerService {
    static let shared: CredentialsCheckerService = CredentialsCheckerService()
    private let login1 = "User"
    private let pswd1 = "StrongPassword"
    
    private let login2 = "Debug User"
    private let pswd2 = "StrongPassword"
    
    private init() {
        
    }
    
    public func check(login: String, password: String) -> Bool {
        var checkPass: String? = nil
        switch login {
        case login1:
            checkPass = pswd1
        case login2:
            checkPass = pswd2
        default:
            return false
        }
        if password == checkPass {
            return true
        }
        return false
    }
}
