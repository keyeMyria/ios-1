// TODO move to voiceMessagesViewModel?

//protocol ConversationsViewModelType {
//  var conversations: Observable<[Conversation]> { get }
//  var currentConversation: Variable<Conversation> { get }
//}
//
//final class ConversationsViewModel: ConversationsViewModelType {
//  private let bag = DisposeBag()
//
//  let conversations = Observable.just((1...30).map {
//    return Conversation(id: $0, converseeID: $0)
//  })
//
//  let currentConversation = Variable<Conversation>(Conversation(id: 1, converseeID: 1))
//
//  init() {
//    currentConversation.asObservable()
//      .distinctUntilChanged { $0.id == $1.id }
//      .subscribe(onNext: { conversation in
//        print("chosen conversation: \(conversation.id)")
//      })
//      .disposed(by: bag)
//  }
//}
