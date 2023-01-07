import Foundation

class BruteForcer {

    private var loginViewControllerDelegate: LoginViewControllerDelegateProtocol?
    
    public func bruteForce(login: String, completion: @escaping (_ password: String) -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
            
            var password: String = ""

            while !Bool(self?.checkCredentials(login: login, password: password) ?? false) {
                password = self?.generateBruteForce(password, fromArray: ALLOWED_CHARACTERS) ?? ""
                print("trying password: \(password)")
            }
            let passwordForLogIn: String = password
            DispatchQueue.main.async {
              completion(passwordForLogIn)
            }
        }
    }
    
    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}

extension BruteForcer: LoginViewControllerDelegateProtocol {
    
    func setLoginViewControllerDelegate(_ loginViewControllerDelegate :LoginViewControllerDelegateProtocol) -> Void {
        self.loginViewControllerDelegate = loginViewControllerDelegate
    }
    
    func checkCredentials(login: String, password: String) -> Bool {
        return loginViewControllerDelegate!.checkCredentials(login: login, password: password)
    }
    
    func checkCredentials(login: String, password: String, _ completion: @escaping () -> Void, _ errorHandler: @escaping () -> Void) -> Void  {
        loginViewControllerDelegate!.checkCredentials(login: login, password: password, completion, errorHandler)
    }
}


fileprivate extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }



    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}
