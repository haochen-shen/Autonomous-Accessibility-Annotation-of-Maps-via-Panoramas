import MapKit

struct Route {
  let origin: MKMapItem
  let stop: MKMapItem

 var annotations: [MKAnnotation] {
    var annotations: [MKAnnotation] = []

    annotations.append(
        RouteAnnotation(item: origin)
    )
    annotations.append(
        RouteAnnotation(item: stop)
    )
    return annotations
  }

    
  var label: String {
      return "Directions to \(stop.name! as String)"
  }
}
