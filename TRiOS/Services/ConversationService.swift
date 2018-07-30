import RxSwift
import GRDB; import RxGRDB

protocol ConversationServiceType {
  func listLocalConversations() -> Observable<[Conversation]>
//  func createLocalConversation(with userID: Int64) -> Observable<Conversation>
}

class ConversationService: ConversationServiceType {

  let dbPool: DatabasePool

  init(dbPool: DatabasePool) {
    self.dbPool = dbPool
  }

  // TODO refactor
//  func createLocalConversation(with userID: Int64) -> Observable<Conversation> {
////    Observable.deferred {
//      do {
//        let conversation = try dbQueue.inDatabase { db -> Conversation in
//          var conversation = Conversation(id: 1, converseeID: userID)
//          try conversation.insert(db)
//          return conversation
//        }
//        return .just(conversation)
//      } catch let error {
//        // log instead of print?
//        print("Failed to create conversation (userID: \(userID)) with error: \(error.localizedDescription)")
//        return .error(error)
//      }
////    }
//  }

  func listLocalConversations() -> Observable<[Conversation]> {
    return Conversation.all().rx.fetchAll(in: dbPool)
  }
}
