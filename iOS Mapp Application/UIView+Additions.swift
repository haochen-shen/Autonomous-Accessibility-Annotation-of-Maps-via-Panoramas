

import UIKit

extension UIView {
  func addBorder() {
    layer.borderWidth = 1
    layer.cornerRadius = 3
    layer.borderColor = UIColor.border.cgColor
  }
}
