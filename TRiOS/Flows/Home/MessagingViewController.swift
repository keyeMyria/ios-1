import UIKit
import Anchorage

final class MessagingViewController: UIViewController {
//  let viewModel: MessagingViewModelType!
  private let onSettingsTapped: () -> Void
  private let onUserSearchTapped: () -> Void
  private let soundWavesViewController = SoundWavesViewController(voiceMessages: [], onVoiceMessageSelected: { _ in })
  private let conversationsViewController = ConversationsViewController(conversations: [], onConversationSelect: { _ in })

  @objc private func settingsButtonTapped() { onSettingsTapped() }
  private let settingsButton = UIButton(type: .system).then {
    $0.setTitle("settings", for: .normal)
    $0.backgroundColor = .red
    $0.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
  }

  // TODO also pass voice messages datasource and conversations data source
  init(onSettingsTapped: @escaping () -> Void, onUserSearchTapped: @escaping () -> Void) {
    self.onSettingsTapped = onSettingsTapped
    self.onUserSearchTapped = onUserSearchTapped
    super.init(nibName: nil, bundle: nil)
  }

  @available (*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MessagingViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(settingsButton)
    settingsButton.leadingAnchor == view.leadingAnchor + 20
    settingsButton.topAnchor == view.topAnchor + 30
    settingsButton.widthAnchor == 90
    settingsButton.heightAnchor == 30

    // add a button to open user search SearchButton()
    // add a button to manage friendships FriendshipsButton()
    // add a button to start recording (tap on one of the conversations)

    // position conversationCollectionViewController at the bottom
//    addChildViewController(conversationCollectionViewController)
//
//    view.addSubview(conversationCollectionViewController.view)
//
//    // TODO find a better way
//    conversationCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
//    conversationCollectionViewController.view.leadingAnchor == view.leadingAnchor
//    conversationCollectionViewController.view.trailingAnchor == view.trailingAnchor
//    conversationCollectionViewController.view.bottomAnchor == view.bottomAnchor - 30
//    conversationCollectionViewController.view.heightAnchor == 100
//
//    conversationCollectionViewController.didMove(toParentViewController: self)
//
//    // position soundWaveCollectionViewController in the middle
//    addChildViewController(soundWaveCollectionViewController)
//    view.addSubview(soundWaveCollectionViewController.view)
//
//    soundWaveCollectionViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 75)
//    soundWaveCollectionViewController.view.leadingAnchor == view.leadingAnchor
//    soundWaveCollectionViewController.view.trailingAnchor == view.trailingAnchor
//    soundWaveCollectionViewController.view.centerYAnchor == view.centerYAnchor
//    soundWaveCollectionViewController.view.heightAnchor == 75
//
//    soundWaveCollectionViewController.didMove(toParentViewController: self)
  }
}
