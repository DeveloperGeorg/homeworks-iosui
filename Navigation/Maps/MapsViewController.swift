import UIKit
import MapKit
import CoreLocation

class MapsViewController: UIViewController, MKMapViewDelegate {
    private var myLastLocation: CLLocation?
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = true
        let configuration = MKStandardMapConfiguration(elevationStyle: .flat)
        configuration.showsTraffic = true
        mapView.preferredConfiguration = configuration
        
        let pointsOfInterestFilter = MKPointOfInterestFilter()
        mapView.pointOfInterestFilter = pointsOfInterestFilter
        
        // Moscow
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
        mapView.delegate = self
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupConstraints()
        
        findUserLocation()
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addWaypoint(longGesture:)))
        mapView.addGestureRecognizer(longGesture)
    }
    @objc func addWaypoint(longGesture: UIGestureRecognizer) {

        let touchPoint = longGesture.location(in: mapView)
        let wayCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: wayCoords.latitude, longitude: wayCoords.longitude)
        mapView.addAnnotations([CapitalAnnotation(
        title: "Go there", coordinate: location.coordinate, info: "")])
        if let myLocation = myLastLocation {
            showRouteOnMap(pickupCoordinate: myLocation.coordinate, destinationCoordinate: location.coordinate)
        }
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
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
            request.requestsAlternateRoutes = true
            request.transportType = .automobile
            let directions = MKDirections(request: request)

            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                if let route = unwrappedResponse.routes.first {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                }
            }
        }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
         renderer.strokeColor = UIColor.blue
         renderer.lineWidth = 4.0
         return renderer
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
            myLastLocation = location
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        // Handle failure to get a user’s location
    }
}
