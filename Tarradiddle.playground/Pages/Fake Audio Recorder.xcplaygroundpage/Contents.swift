import PlaygroundSupport
import UIKit

@testable import TRAppProxy

final class RecorderViewController: UIViewController {
  private let audioSession = AudioSession {
    print("denied record permission")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    do {
      try audioSession.setup()

      let url = try AppFS.audioURL()

      let recorder = try AudioRecorder(url: url, audioSession: audioSession) { meteringLevels in
        print(meteringLevels)
      }

      recorder.setup()
      try recorder.start()
    } catch {
      print(error.localizedDescription)
    }
  }
}

PlaygroundPage.current.liveView = RecorderViewController()
