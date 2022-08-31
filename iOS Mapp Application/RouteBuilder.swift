import MapKit

enum RouteBuilder {
  enum Segment {
    case text(String)
    case location(CLLocation)
  }

  enum RouteError: Error {
    case invalidSegment(String)
  }

  typealias PlaceCompletionBlock = (MKPlacemark?) -> Void
  typealias RouteCompletionBlock = (Result<Route, RouteError>) -> Void

  private static let routeQueue = DispatchQueue(label: "com.raywenderlich.RWRouter.route-builder")

  static func buildRoute(origin: Segment, stop: Segment, within region: MKCoordinateRegion?, completion: @escaping RouteCompletionBlock) {
    routeQueue.async {
        
      let group = DispatchGroup()

      var originItem: MKMapItem?
        
      group.enter()
        
      requestPlace(for: origin, within: region) { place in
        if let requestedPlace = place {
          originItem = MKMapItem(placemark: requestedPlace)
        }
          group.leave()
      }

        var stopItem: MKMapItem?
        group.enter()
        requestPlace(for: stop, within: region) { place in
          if let requestedPlace = place {
            stopItem = MKMapItem(placemark: requestedPlace)
          }
            group.leave()
        }

        group.notify(queue: .main) {
        if let originMapItem = originItem, let stopMapItem = stopItem {
            let route = Route(origin: originMapItem, stop: stopMapItem)
            completion(.success(route))
          } else {
            let reason = originItem == nil ? "the origin address" : "one or more of the stops"
            completion(.failure(.invalidSegment(reason)))
          }
        }
      /*
      group.notify(queue: .main) {
        if let originMapItem = originItem, !stopItem.isEmpty {
          let route = Route(origin: originMapItem, stop: stopItem)
          completion(.success(route))
        } else {
          let reason = originItem == nil ? "the origin address" : "one or more of the stops"
          completion(.failure(.invalidSegment(reason)))
        }
      }
        */
    }
  }

  private static func requestPlace(for segment: Segment, within region: MKCoordinateRegion?, completion: @escaping PlaceCompletionBlock) {
    if case .text(let value) = segment, let nearbyRegion = region {
      let request = MKLocalSearch.Request()
      request.naturalLanguageQuery = value
      request.region = nearbyRegion

      MKLocalSearch(request: request).start { response, _ in
        let place: MKPlacemark?

        if let firstItem = response?.mapItems.first {
          place = firstItem.placemark
        } else {
          place = nil
        }

        completion(place)
      }
    } else {
      CLGeocoder().geocodeSegment(segment) { places, _ in
        let place: MKPlacemark?

        if let firstPlace = places?.first {
          place = MKPlacemark(placemark: firstPlace)
        } else {
          place = nil
        }

        completion(place)
      }
    }
  }
}

private extension CLGeocoder {
  func geocodeSegment(_ segment: RouteBuilder.Segment, completionHandler: @escaping CLGeocodeCompletionHandler) {
    switch segment {
    case .text(let value):
      geocodeAddressString(value, completionHandler: completionHandler)

    case .location(let value):
      reverseGeocodeLocation(value, completionHandler: completionHandler)
    }
  }
}
