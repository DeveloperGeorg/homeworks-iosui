import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.mapType = .standard
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.showsUserLocation = true
        
        let pointsOfInterestFilter = MKPointOfInterestFilter()
        mapView.pointOfInterestFilter = pointsOfInterestFilter
        
        // Москва
        let initialLocation = CLLocationCoordinate2D(
            latitude: 55.75222,
            longitude: 37.61556
        )
        mapView.setCenter(
            initialLocation,
            animated: false
        )
        
        let region = MKCoordinateRegion(
            center: initialLocation,
            latitudinalMeters: 100_000,
            longitudinalMeters: 100_000
        )
        mapView.setRegion(
            region,
            animated: false
        )
        
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        title = "Работа с картой"
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupConstraints()
        
        findUserLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.requestLocation()
    }
    
    private func setupSubviews() {
        setupMapView()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(
                equalTo: safeAreaGuide.leadingAnchor
            ),
            mapView.trailingAnchor.constraint(
                equalTo: safeAreaGuide.trailingAnchor
            ),
            mapView.topAnchor.constraint(
                equalTo: safeAreaGuide.topAnchor
            ),
            mapView.bottomAnchor.constraint(
                equalTo: safeAreaGuide.bottomAnchor
            ),
        ])
    }
    
    private func findUserLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
    }

}

extension MapsViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            print("Определение локации невозможно")
        case .notDetermined:
            print("Определение локации не запрошено")
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let location = locations.first {
            mapView.setCenter(
                location.coordinate,
                animated: true
            )
            mapView.addAnnotations([CapitalAnnotation(
            title: "I'm here", coordinate: location.coordinate, info: "")])
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
}
