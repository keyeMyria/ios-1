import PlaygroundSupport
import UIKit
import Anchorage
import RxSwift
//import RxCocoa

@testable import TRApp

class FakeConversationsViewModel: ConversationsViewModelType {
  let bag = DisposeBag()

  let conversations = Observable.just((1...4).map {
    return Conversation(id: $0, remoteID: $0, userID: $0)
  })

  let currentConversation = Variable<Conversation>(
    Conversation(id: 1, remoteID: 1, userID: 1)
  )

  init() {
    currentConversation.asObservable()
      .distinctUntilChanged { $0.id == $1.id }
      .subscribe(onNext: { conversation in
        print("conversation:", conversation.id!)
      })
      .disposed(by: bag)
  }
}

let viewModel = FakeConversationsViewModel()
let vc = ConversationCollectionViewController()
vc.viewModel = viewModel

// makes view small
// about the same size as in the container vc
let containerSize = CGSize(width: 375, height: 100)
vc.view.frame.size = containerSize
vc.preferredContentSize = containerSize

let centerLine = UIView()
centerLine.backgroundColor = .yellow
vc.view.addSubview(centerLine)
centerLine.topAnchor == vc.view.topAnchor
centerLine.bottomAnchor == vc.view.bottomAnchor
centerLine.centerXAnchor == vc.view.centerXAnchor
centerLine.widthAnchor == 2

PlaygroundPage.current.liveView = vc
