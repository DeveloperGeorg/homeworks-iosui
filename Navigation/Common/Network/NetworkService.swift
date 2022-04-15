import Foundation

struct NetworkService {
    static func run(url: String, query: String, clouseres: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let defaultSession = URLSession(configuration: .default)
            
        // 2
        if var urlComponents = URLComponents(string: url) {
          urlComponents.query = query
          // 3
          guard let url = urlComponents.url else {
            return
          }
          // 4
          let dataTask =
            defaultSession.dataTask(with: url) { data, response, error in
                clouseres(data, response, error)
          }
          dataTask.resume()
        }

    }
}
