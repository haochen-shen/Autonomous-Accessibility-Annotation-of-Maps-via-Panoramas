import UIKit
import MapKit

class ViewController: UIViewController {
  @IBOutlet private var mapView: MKMapView!
  private var objs: [Obj] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Set initial location
    let initialLocation = CLLocation(latitude: 51.498356, longitude: -0.176894)
    mapView.centerToLocation(initialLocation)
    
    let impCenter = CLLocation(latitude: 51.498356, longitude: -0.176894)
    let region = MKCoordinateRegion(
      center: impCenter.coordinate,
      latitudinalMeters: 50000,
      longitudinalMeters: 60000)
    mapView.setCameraBoundary(
      MKMapView.CameraBoundary(coordinateRegion: region),
      animated: true)
    
    let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
    mapView.setCameraZoomRange(zoomRange, animated: true)
    
    mapView.delegate = self
    
    mapView.register(
      ObjView.self,
      forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    loadInitialData()
    mapView.addAnnotations(objs)
  }
  
  private func loadInitialData() {
    // 1
    guard
      let fileName = Bundle.main.url(forResource: "result_geojson", withExtension: "geojson"),
      let objData = try? Data(contentsOf: fileName)
      else {
        return
    }

    do {
      // 2
      let features = try MKGeoJSONDecoder()
        .decode(objData)
        .compactMap { $0 as? MKGeoJSONFeature }
      // 3
      let validWorks = features.compactMap(Obj.init)
      // 4
      objs.append(contentsOf: validWorks)
    } catch {
      // 5
      print("Unexpected error: \(error).")
    }
  }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension ViewController: MKMapViewDelegate {
  func mapView(
    _ mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl
  ) {
    guard let obj = view.annotation as? Obj else {
      return
    }
    
    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    obj.mapItem?.openInMaps(launchOptions: launchOptions)
  }
}

