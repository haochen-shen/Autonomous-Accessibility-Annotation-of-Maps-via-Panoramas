
import UIKit

extension UITextField {
  var contents: String? {
    guard
      let text = text?.trimmingCharacters(in: .whitespaces),
      !text.isEmpty
      else {
        return nil
    }

    return text
  }
}
