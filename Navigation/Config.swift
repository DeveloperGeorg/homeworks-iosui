import Foundation

class Config {
    static let shared = Config()
    
    private let infoDictionary: [String: Any]

    private init() {
        if let infoDictionary: [String: Any] = Bundle.main.infoDictionary {
            self.infoDictionary = infoDictionary
        } else {
            self.infoDictionary = [:]
        }
        print("CONFIG:")
        print(self.infoDictionary)
    }
    
    func getValueByKey(_ key: String) -> String? {
        guard let value: String = infoDictionary[key] as? String else { return  nil}
        return value
    }
}
