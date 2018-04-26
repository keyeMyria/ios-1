// for testing things out

import RxSwift

Observable.from(["hello", "darkness", "my", "old", "friend"])
  .map { $0.uppercased() }
  .subscribe(onNext: { print($0) })
