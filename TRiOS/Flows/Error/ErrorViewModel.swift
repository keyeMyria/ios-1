enum ErrorViewModel {
  struct NetworkError {
    
  }

  struct DatabaseError {

  }

  enum Kind {
    case network(NetworkError)
    case database(DatabaseError)
  }
}
