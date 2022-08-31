import Foundation
import MapKit
import Contacts

class Obj: NSObject, MKAnnotation {
  let name: String?
  let ID: String?
  let coordinate: CLLocationCoordinate2D

  init(
    name: String?,
    ID: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.name = name
    self.ID = ID
    self.coordinate = coordinate

    super.init()
  }
  
  init?(feature: MKGeoJSONFeature) {
    // 1
    guard
      let point = feature.geometry.first as? MKPointAnnotation,
    // 2
      let propertiesData = feature.properties,
      let json = try? JSONSerialization.jsonObject(with: propertiesData),
      let properties = json as? [String: Any]
      else {
        return nil
    }

    // 3
    name = properties["name"] as? String
    ID = properties["ID"] as? String
    coordinate = point.coordinate
    super.init()
  }

  var mapItem: MKMapItem? {

    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = ID
    return mapItem
  }

  var markerTintColor: UIColor  {
    switch name {
    case "steps":
      return .red
    case "ramp":
      return .cyan
    default:
      return .green
    }
  }

  var image: UIImage {
    guard let class_type = name else { return #imageLiteral(resourceName: "Flag") }
    
    switch class_type {
    case "steps":
      return #imageLiteral(resourceName: "Step")
    case "ramp":
      return #imageLiteral(resourceName: "Ramp")
    default:
      return #imageLiteral(resourceName: "Flag")
    }
  }
}
