import UIKit

class InfoViewController: UIViewController {
    weak var coordinator: FeedCoordinator?
    
    public init(coordinator: FeedCoordinator?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
    }
    override func loadView() {
        let view = InfoView()
        self.view = view
        view.button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        loadTask(taskId: 1) { data, response, error in
            if let unwrappedData = data {
                do {
                    let serializedDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: [])
                    if let dict = serializedDictionary as? [String: Any] {
                       let task = TaskDto(
                           userId: dict["userId"] as! Int,
                           id: dict["id"] as! Int,
                           title: dict["title"] as! String,
                           completed: dict["completed"] as! Bool
                       )
                        DispatchQueue.main.async {
                            view.taskLabel.text = task.title
                        }
                    }
                }
                catch let error {
                    print("[TASK] ERROR: \(error.localizedDescription)")
                }
            }
        }
        loadPlanet(planetId: 1) { data, response, error in
            if let unwrappedData = data {
                do {
                    let planet = try JSONDecoder().decode(PlanetDto.self, from: unwrappedData)
                    DispatchQueue.main.async {
                        view.planetLabel.text = "Период обращения планеты Татуин \nвокруг своей звезды: \(planet.orbitalPeriod)"
                    }
                }
                catch let error {
                    print("[PLANET] ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func showAlert()
    {
        coordinator?.showAlert()
    }
    
    func loadTask(taskId: Int, clouseres: @escaping (Data?, URLResponse?, Error?) -> Void) -> Void {
        let url = "https://jsonplaceholder.typicode.com/todos/\(taskId)"
        let defaultSession = URLSession(configuration: .default)
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else {
                return
            }
            let dataTask = defaultSession.dataTask(with: url) { data, response, error in
                clouseres(data, response, error)
            }
            dataTask.resume()
        }
    }
    
    func loadPlanet(planetId: Int, clouseres: @escaping (Data?, URLResponse?, Error?) -> Void ) -> Void {
        let url = "https://swapi.dev/api/planets/\(planetId)"
        let defaultSession = URLSession(configuration: .default)
        if let urlComponents = URLComponents(string: url) {
            guard let url = urlComponents.url else {
                return
            }
            let dataTask = defaultSession.dataTask(with: url) { data, response, error in
                clouseres(data, response, error)
            }
            dataTask.resume()
        }
    }
}
