//
//  MapViewController.swift
//  MapSearch
//

import Combine
import UIKit
import YandexMapsMobile

class OptionsViewController: UIViewController {
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubscriptions()

        setupSubviews()
        configureContentInfo()
        view.backgroundColor = .white
    }

    // MARK: - Private methods

    private func setupSubviews() {
        view.addSubview(optionsView)
        optionsView.axis = .vertical
        optionsView.alignment = .fill
        optionsView.spacing = 10
        optionsView.translatesAutoresizingMaskIntoConstraints = false

        progressView.isHidden = true
        dividerView.backgroundColor = .black

        cellularNetworkView.checkBox.delegate = self
        cellularNetworkView.checkBox.type = .cellularNetwork
        autoEnabledView.checkBox.delegate = self
        autoEnabledView.checkBox.type = .autoEnabled

        cachesPathTitleLabel.textColor = .black
        cachesPathTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        cachesPathTextView.textColor = .black
        cachesPathTextView.delegate = self
        cachesPathTextView.font = UIFont.systemFont(ofSize: 16)

        cashSizeButton.translatesAutoresizingMaskIntoConstraints = false
        cashSizeButton.layer.cornerRadius = 4
        cashSizeButton.setTitleColor(.black, for: .normal)
        cashSizeButton.contentMode = .scaleAspectFill
        cashSizeButton.backgroundColor = Palette.background

        clearSizeButton.translatesAutoresizingMaskIntoConstraints = false
        clearSizeButton.layer.cornerRadius = 4
        clearSizeButton.setTitleColor(.black, for: .normal)
        clearSizeButton.contentMode = .scaleAspectFill
        clearSizeButton.backgroundColor = Palette.background

        pathButtonsView.axis = .horizontal
        pathButtonsView.distribution = .fillEqually
        pathButtonsView.spacing = 10
        pathButtonsView.translatesAutoresizingMaskIntoConstraints = false

        [
            optionsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            optionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.defaultInset),
            optionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.defaultInset)
        ]
        .forEach { $0.isActive = true }

        [cellularNetworkView, autoEnabledView, cashSizeButton, clearSizeButton,
         cachesPathTitleLabel, cachesPathTextView, dividerView, pathButtonsView, progressView]
            .forEach {
                optionsView.addArrangedSubview($0)
            }

        [
            progressView.heightAnchor.constraint(equalToConstant: Layout.progressViewHeight)
        ]
        .forEach { $0.isActive = true }

        optionsView.setCustomSpacing(25, after: cellularNetworkView)
        optionsView.setCustomSpacing(40, after: autoEnabledView)

        [
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ]
        .forEach { $0.isActive = true }

        [
            cachesPathTextView.heightAnchor.constraint(equalToConstant: Layout.cachesPathTextViewHeight)
        ]
        .forEach { $0.isActive = true }

        [
            cashSizeButton.widthAnchor.constraint(equalToConstant: Layout.buttonWidth),
            cashSizeButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ]
        .forEach { $0.isActive = true }

        [
            clearSizeButton.widthAnchor.constraint(equalToConstant: Layout.buttonWidth),
            clearSizeButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ]
        .forEach { $0.isActive = true }

        [moveButton, switchButton]
            .forEach {
                pathButtonsView.addArrangedSubview($0)

                $0.translatesAutoresizingMaskIntoConstraints = false
                [
                    $0.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
                ]
                .forEach { $0.isActive = true }

                $0.layer.cornerRadius = 4
                $0.setTitleColor(.black, for: .normal)
                $0.contentMode = .scaleAspectFill
                $0.backgroundColor = Palette.background
            }

        pathButtonsView.addArrangedSubview(UIView())

        cashSizeButton.addTarget(
            self,
            action: #selector(cashSizeButtonTapHandler),
            for: .touchUpInside
        )

        clearSizeButton.addTarget(
            self,
            action: #selector(clearButtonTapHandler),
            for: .touchUpInside
        )

        moveButton.addTarget(
            self,
            action: #selector(moveButtonTapHandler),
            for: .touchUpInside
        )

        switchButton.addTarget(
            self,
            action: #selector(switchButtonTapHandler),
            for: .touchUpInside
        )
    }

    private func setupSubscriptions() {
        setupProgressSubscriptions()
        setupSuccessMoveSubscriptions()
        setupErrorMoveSubscriptions()
    }

    private func setupProgressSubscriptions() {
        optionsViewModel.$progress.sink { [weak self] progress in
            self?.progressView.isHidden = false
            self?.progressView.configureView(value: progress ?? .zero)
        }
        .store(in: &bag)
    }

    private func setupSuccessMoveSubscriptions() {
        optionsViewModel.$isSuccessMove.sink { [weak self] _ in
            self?.progressView.isHidden = true
            let alert = UIAlertController(
                title: "",
                message: "Caches moved to: \(self?.cachesPathTextView.text ?? "")",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

            self?.present(alert, animated: true)
        }
        .store(in: &bag)
    }

    private func setupErrorMoveSubscriptions() {
        optionsViewModel.$errorText.sink { [weak self] text in
            self?.progressView.isHidden = true
            let alert = UIAlertController(
                title: "",
                message: "Error on moving: \(text ?? "")",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

            self?.present(alert, animated: true)
        }
        .store(in: &bag)
    }

    private func configureContentInfo() {
        cachesPathTitleLabel.text = "Caches path"
        offlineManager.requestPath(pathGetterListener: { [weak self] path in
            self?.cachesPathTextView.text = path
        })

        cashSizeButton.setTitle("CASHE SIZE", for: .normal)
        clearSizeButton.setTitle("CLEAR CACHE", for: .normal)
        moveButton.setTitle("MOVE", for: .normal)
        switchButton.setTitle("SWITCH", for: .normal)

        cellularNetworkView.checkBox.isChecked = UserStorage.isCellularNetwork
        autoEnabledView.checkBox.isChecked = UserStorage.isAutoUpdate
    }

    @objc
    private func cashSizeButtonTapHandler() {
        offlineManager.computeCacheSize { [weak self] number in
            let alert = UIAlertController(
                title: "",
                message: "Total size caches: \(number ?? NSNumber()) bytes",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

            self?.present(alert, animated: true)
        }
    }

    @objc
    private func clearButtonTapHandler() {
        offlineManager.clear {
            let alert = UIAlertController(
                title: "",
                message: "All caches were cleared",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

            self.present(alert, animated: true)
        }
    }

    @objc
    private func moveButtonTapHandler() {
        offlineManager.moveData(withNewPath: self.cachesPathTextView.text, dataMoveListener: dataMoveListener)
    }

    @objc
    private func switchButtonTapHandler() {
        offlineManager.setCachePathWithPath(self.cachesPathTextView.text) { [weak self] error in
            let alert = UIAlertController(
                title: "",
                message: "Error on setting path: \(error?.localizedDescription ?? "")",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

            self?.present(alert, animated: true)
        }
    }

    // MARK: - Private properties

    private let optionsView = UIStackView()
    private let cellularNetworkView = TitleCheckBoxView(title: "Allow cellular network")
    private let autoEnabledView = TitleCheckBoxView(title: "Auto update enabled")
    private let cashSizeButton = UIButton()
    private let clearSizeButton = UIButton()
    private let cachesPathTitleLabel = UILabel()
    private let cachesPathTextView = UITextView()
    private let dividerView = UIView()
    private let pathButtonsView = UIStackView()
    private let moveButton = UIButton()
    private let switchButton = UIButton()
    private let progressView = ProgressView()

    private let optionsViewModel = OptionsViewModel()

    private lazy var dataMoveListener = DataMoveListener(optionViewModel: optionsViewModel)
    private lazy var offlineManager = YMKMapKit.sharedInstance().offlineCacheManager

    private var bag = Set<AnyCancellable>()

    // MARK: - Layout

    private enum Layout {
        static let buttonHeight: CGFloat = 36.0
        static let defaultInset: CGFloat = 20.0
        static let buttonWidth: CGFloat = 60.0
        static let cachesPathTextViewHeight = 80.0
        static let progressViewHeight = 6.0
    }
}

extension OptionsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.cachesPathTextView.text = textView.text
    }
}

extension OptionsViewController: CheckBoxDelegate {
    func tapCheckbox(isChecked: Bool, type: CheckBox.CheckboxType) {
        switch type {
        case .cellularNetwork:
            UserStorage.isCellularNetwork = isChecked
            offlineManager.allowUseCellularNetwork(withUseCellular: isChecked)
        case .autoEnabled:
            UserStorage.isAutoUpdate = isChecked
            offlineManager.enableAutoUpdate(withEnable: isChecked)
        }
    }
}
