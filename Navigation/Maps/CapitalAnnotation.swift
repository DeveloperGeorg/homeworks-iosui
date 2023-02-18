import Foundation
import MapKit

// MKAnnotationView

final class CapitalAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(
        title: String,
        coordinate: CLLocationCoordinate2D,
        info: String
    ) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        
        super.init()
    }
}
