import UIKit
import RxSwift
import RxCocoa
import Anchorage

final class MessagingViewController: UIViewController {
//  let viewModel: MessagingViewModelType!
  private let bag = DisposeBag()

  // child view controllers

  let soundWaveCollectionViewController: SoundWaveCollectionViewController = {
    let soundWaveCollectionViewController = SoundWaveCollectionViewController()
    soundWaveCollectionViewController.viewModel = VoiceMessagesViewModel()
    return soundWaveCollectionViewController
  }()

  let conversationCollectionViewController: ConversationCollectionViewController = {
    let conversationCollectionViewController = ConversationCollectionViewController()
    conversationCollectionViewController.viewModel = ConversationsViewModel()
    return conversationCollectionViewController
  }()

  let settingsButton: UIButton = {
    let settingsButton = UIButton(type: .system)
    settingsButton.setTitle("settings", for: .normal)
    settingsButton.backgroundColor = .red
    return settingsButton
  }()

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    conversationCollectionViewController.view.frame.size.width = view.frame.width // TODO need it?
    soundWaveCollectionViewController.view.frame.size.width = view.frame.width
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // adds a button to open settings
    view.addSubview(settingsButton)
    settingsButton.leadingAnchor == view.leadingAnchor + 20
    settingsButton.topAnchor == view.topAnchor + 30
    settingsButton.widthAnchor == 90
    settingsButton.heightAnchor == 30

    settingsButton.rx.tap
      .subscribe(onNext: {
        print("settings button tapped")
      })
      .disposed(by: bag)

    // add a button to open user search SearchButton()
    // add a button to manage friendships FriendshipsButton()
    // add a button to start recording (tap on one of the conversations)

    // position conversationCollectionViewController at the bottom
    addChildViewController(conversationCollectionViewController)

    view.addSubview(conversationCollectionViewController.view)

    // TODO find a better way
    conversationCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
    conversationCollectionViewController.view.leadingAnchor == view.leadingAnchor
    conversationCollectionViewController.view.trailingAnchor == view.trailingAnchor
    conversationCollectionViewController.view.bottomAnchor == view.bottomAnchor - 30
    conversationCollectionViewController.view.heightAnchor == 100

    conversationCollectionViewController.didMove(toParentViewController: self)

    // position soundWaveCollectionViewController in the middle
    addChildViewController(soundWaveCollectionViewController)
    view.addSubview(soundWaveCollectionViewController.view)

    soundWaveCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 75)
    soundWaveCollectionViewController.view.leadingAnchor == view.leadingAnchor
    soundWaveCollectionViewController.view.trailingAnchor == view.trailingAnchor
    soundWaveCollectionViewController.view.centerYAnchor == view.centerYAnchor
    soundWaveCollectionViewController.view.heightAnchor == 75

    soundWaveCollectionViewController.didMove(toParentViewController: self)
  }
}
