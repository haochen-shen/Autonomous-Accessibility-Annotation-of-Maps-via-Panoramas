import Foundation
import MapKit

class ObjMarkerView: MKMarkerAnnotationView {
    
    
    override var annotation: MKAnnotation? {
    willSet {
      // 1
      guard let obj = newValue as? Obj else {
        return
      }
      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

      // 2
      markerTintColor = obj.markerTintColor
      glyphImage = obj.image
    }
  }
}

class ObjView: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let obj = newValue as? Obj else {
        return
      }

      canShowCallout = true
      calloutOffset = CGPoint(x: -5, y: 5)
      let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
      mapsButton.setBackgroundImage(#imageLiteral(resourceName: "Map"), for: .normal)
      rightCalloutAccessoryView = mapsButton

      image = obj.image
      
      let detailLabel = UILabel()
      detailLabel.numberOfLines = 0
      detailLabel.font = detailLabel.font.withSize(12)
      detailCalloutAccessoryView = detailLabel
    }
  }
}

