import PlaygroundSupport
import UIKit

@testable import TRAppProxy
import Anchorage

//class FakeConversationsViewModel: ConversationsViewModelType {
//  let bag = DisposeBag()
//
//  let conversations = Observable.just((1...4).map {
//    return Conversation(id: $0, remoteID: $0, userID: $0)
//  })
//
//  let currentConversation = Variable<Conversation>(
//    Conversation(id: 1, remoteID: 1, userID: 1)
//  )
//
//  init() {
//    currentConversation.asObservable()
//      .distinctUntilChanged { $0.id == $1.id }
//      .subscribe(onNext: { conversation in
//        print("conversation:", conversation.id!)
//      })
//      .disposed(by: bag)
//  }
//}

let conversations = (1...4).map { Conversation(id: $0, converseeID: $0) }
let vc = ConversationsViewController(conversations: conversations) { conversation in
  print("conversation:", conversation.id)
}

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
