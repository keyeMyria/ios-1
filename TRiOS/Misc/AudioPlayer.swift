import Foundation
import AVFoundation

// from https://www.youtube.com/watch?v=--SKKX1DdGc
extension Notification.Name {
  static let AudioPlayerDidFinishPlayingAudioFile = Notification.Name("AudioPlayerDidFinishPlayingAudioFile")
}

final class AudioPlayer: NSObject {

//  static let shared = AudioRecorderManager()

  private var currentPlayer: AVAudioPlayer?

  var isPlaying = false
  var isFinished = true

  var lastPath: String?

  func play(path: String) {
    if path == lastPath && !isFinished {
      currentPlayer?.play()
      return
    }

    let url = URL(string: path)

    do {
      currentPlayer = try AVAudioPlayer(contentsOf: url!)
      currentPlayer?.delegate = self
      currentPlayer?.play()
      isPlaying = true
      isFinished = false
      lastPath = url?.path
    } catch {
      print("error loading file", error.localizedDescription)
    }
  }

  func pause() {
    currentPlayer?.pause()
    isPlaying = false
  }

  static func getFilePath(filename: String) throws -> String {
    return try FileManager.default.url(
      for: .applicationSupportDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
      ).appendingPathComponent(filename + ".m4a").path
  }
}

extension AudioPlayer: AVAudioPlayerDelegate {
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    isPlaying = false
    isFinished = true
    NotificationCenter.default.post(name: Notification.Name.AudioPlayerDidFinishPlayingAudioFile, object: nil)
  }

  func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
    print(error?.localizedDescription ?? "")
  }
}
