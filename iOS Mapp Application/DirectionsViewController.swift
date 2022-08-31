import UIKit
import MapKit
import CoreLocation

class DirectionsViewController: UIViewController {
  @IBOutlet private var mapView_nav: MKMapView!
  @IBOutlet private var headerLabel: UILabel!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var informationLabel: UILabel!
  @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

  private let cellIdentifier = "DirectionsCell"
  private let distanceFormatter = MKDistanceFormatter()

  private let route: Route

  private var mapRoutes: [MKRoute] = []
  private var totalTravelTime: TimeInterval = 0
  private var totalDistance: CLLocationDistance = 0

  private var groupedRoutes: [(startItem: MKMapItem, endItem: MKMapItem)] = []
    
  private var objs: [Obj] = []

  init(route: Route) {
    
    self.route = route

    super.init(nibName: String(describing: DirectionsViewController.self), bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    groupAndRequestDirections()

    headerLabel.text = route.label

    tableView.dataSource = self
      
    
    //mapView_nav.register(
    //  ObjView.self,
      //forAnnotationViewWithReuseIdentifier: //MKMapViewDefaultAnnotationViewReuseIdentifier)
    
    loadInitialData()
    mapView_nav.addAnnotations(objs)
      
    mapView_nav.delegate = self
    mapView_nav.showAnnotations(route.annotations, animated: false)
    
      
  }
    
    
    // MARK: - Objects detection
    private func loadInitialData() {
      // 1
      guard
        let fileName = Bundle.main.url(forResource: "result_geojson_0.3_0.15x10", withExtension: "geojson"),
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

  // MARK: - Helpers

  private func groupAndRequestDirections() {
      /*
    guard let firstStop = route.stops.first else {
      return
    }
       */

      
    groupedRoutes.append((route.origin, route.stop))

      /*
    if route.stops.count == 2 {
      let secondStop = route.stops[1]

      groupedRoutes.append((firstStop, secondStop))
      groupedRoutes.append((secondStop, route.origin))
    }
       */
    

    fetchNextRoute()
  }

  private func fetchNextRoute() {
    guard !groupedRoutes.isEmpty else {
      activityIndicatorView.stopAnimating()
      return
    }

    let nextGroup = groupedRoutes.removeFirst()
    let request = MKDirections.Request()

    request.source = nextGroup.startItem
    request.destination = nextGroup.endItem
      
    request.transportType =  [.walking]

    let directions = MKDirections(request: request)

    directions.calculate { response, error in
      guard let mapRoute = response?.routes.first else {
        self.informationLabel.text = error?.localizedDescription
        self.activityIndicatorView.stopAnimating()
        return
      }

      self.updateView(with: mapRoute)
      self.fetchNextRoute()
    }
  }

  private func updateView(with mapRoute: MKRoute) {
    let padding: CGFloat = 8
    mapView_nav.addOverlay(mapRoute.polyline)
    mapView_nav.setVisibleMapRect(
    mapView_nav.visibleMapRect.union(
        mapRoute.polyline.boundingMapRect
      ),
      edgePadding: UIEdgeInsets(
        top: 0,
        left: padding,
        bottom: padding,
        right: padding
      ),
      animated: true
    )

    totalDistance += mapRoute.distance
    totalTravelTime += mapRoute.expectedTravelTime

    let informationComponents = [
      totalTravelTime.formatted,
      "• \(distanceFormatter.string(fromDistance: totalDistance))"
    ]
    informationLabel.text = informationComponents.joined(separator: " ")

    mapRoutes.append(mapRoute)
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension DirectionsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return mapRoutes.isEmpty ? 0 : mapRoutes.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let route = mapRoutes[section]
    return route.steps.count - 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = { () -> UITableViewCell in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.selectionStyle = .none
        return cell
      }
      return cell
    }()

    let route = mapRoutes[indexPath.section]
    let step = route.steps[indexPath.row + 1]

    cell.textLabel?.text = "\(indexPath.row + 1): \(step.notice ?? step.instructions)"
    cell.detailTextLabel?.text = distanceFormatter.string(
      fromDistance: step.distance
    )

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let route = mapRoutes[section]
    return route.name
  }
}

// MARK: - MKMapViewDelegate

extension DirectionsViewController: MKMapViewDelegate {
    
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
    
  func mapView(
    _ mapView_nav: MKMapView,
    rendererFor overlay: MKOverlay
  ) -> MKOverlayRenderer {
      
    let renderer = MKPolylineRenderer(overlay: overlay)

    renderer.strokeColor = .systemBlue
    renderer.lineWidth = 3
      

    return renderer
  }
    
}
