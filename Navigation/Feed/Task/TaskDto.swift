import Foundation

struct TaskDto: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
