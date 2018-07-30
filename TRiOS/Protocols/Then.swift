import Foundation.NSObject

protocol Then {}

extension Then where Self: AnyObject {
  func then(_ block: (Self) throws -> Void) rethrows -> Self {
    try block(self)
    return self
  }
}

extension NSObject: Then {}
