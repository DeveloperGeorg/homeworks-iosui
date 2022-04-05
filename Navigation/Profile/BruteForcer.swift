import Foundation

class BruteForcer {
    private var counter = 0;
    private var maxCounter = 20;
    private var loginViewControllerDelegate: LoginViewControllerDelegateProtocol?
    
    public func bruteForce(login: String, completion: @escaping (_ password: String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            var correctPassword: String? = nil
            while(correctPassword == nil) {
                let password: String = self?.generatePass() ?? ""
                let checkResult: Bool = Bool(self?.checkCredentials(login: login, password: password) ?? false)
                if (checkResult == true) {
                    correctPassword = password
                }
                print("trying password: \(password), check result: \(checkResult), correct password: \(correctPassword)")
            }
            
            let passwordForLogIn: String = correctPassword!
          DispatchQueue.main.async {
            completion(passwordForLogIn)
          }
        }
    }
    
    private func generatePass() -> String {
        print("counter: \(counter)")
        counter += 1
        if (counter >= maxCounter) {
            return "StrongPassword"
        }
        return self.generateRandomString(length: Int(arc4random_uniform(20)))
    }
    
    private func generateRandomString(length: Int = 20) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
}

extension BruteForcer: LoginViewControllerDelegateProtocol {
    
    func setLoginViewControllerDelegate(_ loginViewControllerDelegate :LoginViewControllerDelegateProtocol) -> Void {
        self.loginViewControllerDelegate = loginViewControllerDelegate
    }
    
    func checkCredentials(login: String, password: String) -> Bool {
        return loginViewControllerDelegate!.checkCredentials(login: login, password: password)
    }
}
