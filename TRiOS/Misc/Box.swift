final class Box<T> {
  typealias Observer = (T) -> Void

  var observer: Observer?
  var value: T {
    didSet { observer?(value) }
  }

  init(value: T) {
    self.value = value
  }

  func bind(observer: Observer?) {
    self.observer = observer
    observer?(value)
  }
}
