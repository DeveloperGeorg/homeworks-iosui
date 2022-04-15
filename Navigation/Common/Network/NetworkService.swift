import Foundation

struct NetworkService {
    static func run(url: String, query: String, clouseres: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let defaultSession = URLSession(configuration: .default)
        if var urlComponents = URLComponents(string: url) {
          urlComponents.query = query
          guard let url = urlComponents.url else {
            return
          }
          let dataTask =
            defaultSession.dataTask(with: url) { data, response, error in
                clouseres(data, response, error)
          }
          dataTask.resume()
        }

    }
}
