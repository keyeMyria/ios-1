import GRDB

protocol LocalConversationServiceType {
  func listConversations(callback: @escaping (Result<[Conversation], AnyError>) -> Void)
//  func createConversation(with userID: Int64, callback: @escaping (Result<User, AnyError>) -> Void)
  func loadVoiceMessages(for conversation: Conversation,
                         callback: @escaping (Result<[VoiceMessage], AnyError>) -> Void)
}

final class LocalConversationService: LocalConversationServiceType {
  private let dbQueue: DatabaseQueue

  init(dbQueue: DatabaseQueue) {
    self.dbQueue = dbQueue
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

  func listConversations(callback: @escaping (Result<[Conversation], AnyError>) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let conversations = try self.dbQueue.read { try Conversation.fetchAll($0) }
        DispatchQueue.main.async { callback(.success(conversations)) }
      } catch {
        DispatchQueue.main.async { callback(.failure(AnyError(error))) }
      }
    }
  }

  func loadVoiceMessages(for conversation: Conversation,
                         callback: @escaping (Result<[VoiceMessage], AnyError>) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let voiceMessages = try self.dbQueue.read { db in
          try conversation.voiceMessagesRequest.fetchAll(db)
        }
        DispatchQueue.main.async { callback(.success(voiceMessages)) }
      } catch {
        DispatchQueue.main.async { callback(.failure(AnyError(error))) }
      }
    }
  }
}
