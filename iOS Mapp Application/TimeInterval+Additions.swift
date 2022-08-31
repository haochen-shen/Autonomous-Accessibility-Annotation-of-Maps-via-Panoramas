

import Foundation

extension TimeInterval {
  var formatted: String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .full
    formatter.allowedUnits = [.hour, .minute]

    return formatter.string(from: self) ?? ""
  }
}
