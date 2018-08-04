/// See https://github.com/sergdort/CleanArchitectureRxSwift#application-1
protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
