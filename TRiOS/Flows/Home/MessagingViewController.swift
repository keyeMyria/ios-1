import UIKit
import Anchorage

final class MessagingViewController: UIViewController {
//  let viewModel: MessagingViewModelType!
  private let conversations: [Conversation]
  private let conversationService: LocalConversationServiceType
  private let audioService: AudioServiceType
  private let onSettingsTapped: () -> Void
  private let onUserSearchTapped: () -> Void

  private lazy var childSoundWavesViewController = SoundWavesViewController { [unowned self] selectedVoiceMessage in
    print("selected voice message", selectedVoiceMessage)
  }

  private lazy var childConversationsViewController = ConversationsViewController(
    conversations: conversations,
    onConversationSelect: { [unowned self] selectedConversation in
      self.currentConversation = selectedConversation
    },
    onAddConversationSelect: { print("add new selected") },
    onConversationRecording: { [unowned self] state in
      switch state {
      case let .started(conversation: conversation):
        do {
          try self.audioService.startRecording(for: conversation) // result?
        } catch {
          print("starting recording error", error)
        }
      case .cancelled:
        do {
          try self.audioService.cancelRecording()
        } catch {
          print("cancelling recording error", error)
        }
      case .ended:
        self.audioService.finishRecording { [weak self] result in
          switch result {
          // TODO
          case let .success((url: url, meters: meters)): ()
          case let .failure(error): ()
          }
        }
      }
    }
  )

  private var currentConversation: Conversation? {
    didSet {
      guard let currentConversation = currentConversation else { return }
      if currentConversation != oldValue {
        conversationService.loadVoiceMessages(for: currentConversation) { [weak self] result in
          if case let .success(voiceMessages) = result {
            self?.childSoundWavesViewController.voiceMessages = voiceMessages
          }
        }
      }
    }
  }

  @objc private func settingsButtonTapped() { onSettingsTapped() }
  private let settingsButton = UIButton(type: .system).then {
    $0.setTitle("⚙️", for: .normal)
    $0.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
  }

  @objc private func userSearchButtonTapped() { onUserSearchTapped() }
  private let userSearchButton = UIButton(type: .system).then {
    $0.setTitle("🔍", for: .normal)
    $0.addTarget(self, action: #selector(userSearchButtonTapped), for: .touchUpInside)
  }

  // TODO also pass voice messages datasource and conversations data source
  init(conversations: [Conversation],
       conversationService: LocalConversationServiceType,
       audioService: AudioServiceType,
       onSettingsTapped: @escaping () -> Void,
       onUserSearchTapped: @escaping () -> Void) {
    self.conversations = conversations
    // TODO present "add friends screen", or talk to yourself
    currentConversation = conversations.first
    self.conversationService = conversationService
    self.audioService = audioService
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
    view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

    view.addSubview(settingsButton)
    settingsButton.trailingAnchor == view.trailingAnchor - 20
    settingsButton.topAnchor == view.topAnchor + 30
    settingsButton.heightAnchor == 30

    view.addSubview(userSearchButton)
    userSearchButton.leadingAnchor == view.leadingAnchor + 20
    userSearchButton.topAnchor == settingsButton.topAnchor
    userSearchButton.heightAnchor == settingsButton.heightAnchor

    addChildViewController(childConversationsViewController)
    let childConversationsViewControllerView: UIView = childConversationsViewController.view
    view.addSubview(childConversationsViewControllerView)
    childConversationsViewControllerView.leadingAnchor == view.leadingAnchor
    childConversationsViewControllerView.trailingAnchor == view.trailingAnchor
    childConversationsViewControllerView.bottomAnchor == view.bottomAnchor - 30
    childConversationsViewControllerView.heightAnchor == 100
    childConversationsViewController.didMove(toParentViewController: self)

    addChildViewController(childSoundWavesViewController)
    let childSoundWavesViewControllerView: UIView = childSoundWavesViewController.view
    view.addSubview(childSoundWavesViewControllerView)
    childSoundWavesViewControllerView.leadingAnchor == view.leadingAnchor
    childSoundWavesViewControllerView.trailingAnchor == view.trailingAnchor
    childSoundWavesViewControllerView.centerYAnchor == view.centerYAnchor
    childSoundWavesViewControllerView.heightAnchor == 175
    childSoundWavesViewController.didMove(toParentViewController: self)
  }
}
