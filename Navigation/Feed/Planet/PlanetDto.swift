import Foundation

struct PlanetDto: Decodable {
    let name: String
    let rotationPeriod: Int
    let orbitalPeriod: Int
    let diameter: Int
    let climate: String
    let gravity: String
    let terrain: String
    let surfaceWater: Int
    let population: Int
    let residents: [String]
    let films: [String]
    let created: String
    let edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter
        case climate
        case gravity
        case terrain
        case surfaceWater = "surface_water"
        case population
        case residents
        case films
        case created
        case edited
        case url
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            rotationPeriod = try Int(container.decode(String.self, forKey: .rotationPeriod))!
            orbitalPeriod = try Int(container.decode(String.self, forKey: .orbitalPeriod))!
            diameter = try Int(container.decode(String.self, forKey: .diameter))!
            climate = try container.decode(String.self, forKey: .climate)
            gravity = try container.decode(String.self, forKey: .gravity)
            terrain = try container.decode(String.self, forKey: .terrain)
            surfaceWater = try Int(container.decode(String.self, forKey: .surfaceWater))!
            population = try Int(container.decode(String.self, forKey: .population))!
            residents = try container.decode([String].self, forKey: .residents)
            films = try container.decode([String].self, forKey: .films)
            created = try container.decode(String.self, forKey: .created)
            edited = try container.decode(String.self, forKey: .edited)
            url = try container.decode(String.self, forKey: .url)
        }
}
