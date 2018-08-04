import AVFoundation

protocol AudioPlayerType {}

enum AudioPlayerError: RankedError {
  var severity: RankedErrorSeverity {
    return .init(level: .medium, duration: .permanent)
  }

  case initialization(error: Error)
}

// TODO try playing messages while: answering phone calls, playing audio in other apps

final class AudioPlayer: NSObject, AudioPlayerType {
  private let audioSession: AudioSessionType
  private let player: AVAudioPlayer
  private let onStateChange: (State) -> Void

  enum State {
    case initialized
    case playing
    case paused
    case finished
  }

  private var _state: State = .initialized {
    didSet {
      if _state != oldValue {
        onStateChange(_state)
      }
    }
  }

  var state: State { return _state }

  init(url: URL,
       audioSession: AudioSessionType,
       onStateChange: @escaping (State) -> Void) throws {
    self.onStateChange = onStateChange
    self.audioSession = audioSession
    do {
      player = try AVAudioPlayer(contentsOf: url)
      super.init()
      player.delegate = self
    } catch {
      throw AudioRecorderError.initialization(error: error)
    }
  }

  func play() throws {
    try audioSession.activate()
    player.play()
    _state = .playing
  }

//  func play(url: URL)

//  func play(path: String) {
//    player.ur
//    if path == lastPath && !isFinished {
//      currentPlayer?.play()
//      return
//    }

//    let url = URL(string: path)
//
//    do {
//      currentPlayer = try AVAudioPlayer(contentsOf: url!)
//      currentPlayer?.delegate = self
//      currentPlayer?.play()
//      isPlaying = true
//      isFinished = false
//      lastPath = url?.path
//    } catch {
//      print("error loading file", error.localizedDescription)
//    }
//  }

  func pause() {
    player.pause()
    _state = .paused
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    try? audioSession.deactivate()
    _state = .finished
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    print(error?.localizedDescription ?? "")
  }
}
