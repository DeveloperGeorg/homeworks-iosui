import Foundation

enum AppConfiguration: String, CaseIterable {
    case peopleList = "https://swapi.dev/api/people/"
    case person8 = "https://swapi.dev/api/people/8"
    case planets5 = "https://swapi.dev/api/planets/5"
    
    var description: String {
        return self.rawValue
    }
}
