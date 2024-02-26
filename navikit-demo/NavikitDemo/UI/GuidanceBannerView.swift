//
//  GuidanceBannerView.swift
//

import Combine
import UIKit
import YandexMapsMobile

final class GuidanceBannerView: UIView {
    // MARK: - Constructor

    init(viewModel: GuidanceViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setupSubscription()
        setupSubviews()

        viewModel.startIfNotYet()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubviews() {
        let stack = UIStackView(arrangedSubviews: [
            distanceLeftLabel,
            timeLeftLabel,
            flagsLabel,
            roadLabel,
            speedLabel
        ])

        [
            distanceLeftLabel,
            timeLeftLabel,
            flagsLabel,
            roadLabel,
            speedLabel
        ]
        .forEach {
            $0.textColor = .black
            $0.textAlignment = .natural
        }

        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.setTitleColor(.tintColor, for: .normal)
        cancelButton.backgroundColor = Palette.background
        cancelButton.layer.cornerRadius = Layout.cornerRadius
        cancelButton.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)

        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false

        let buttonSimulationSpeedMinus = UIButton()
        let buttonSimulationSpeedPlus = UIButton()

        simulationSpeedLabel.textColor = .black

        speedStack = UIStackView(arrangedSubviews: [
            buttonSimulationSpeedMinus,
            simulationSpeedLabel,
            buttonSimulationSpeedPlus
        ])
        speedStack.axis = .horizontal
        speedStack.distribution = .equalSpacing

        speedStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedStack)

        buttonSimulationSpeedMinus.setTitleColor(.tintColor, for: .normal)
        buttonSimulationSpeedPlus.setTitleColor(.tintColor, for: .normal)

        buttonSimulationSpeedMinus.setImage(UIImage(systemName: "minus"), for: .normal)
        buttonSimulationSpeedPlus.setImage(UIImage(systemName: "plus"), for: .normal)

        buttonSimulationSpeedMinus.addTarget(
            self,
            action: #selector(handleSimulationSpeedMinusButtonTap),
            for: .touchUpInside
        )
        buttonSimulationSpeedPlus.addTarget(
            self,
            action: #selector(handleSimulationSpeedPlusButtonTap),
            for: .touchUpInside
        )

        [
            heightAnchor.constraint(equalToConstant: Const.height),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: Const.spacing),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Const.spacing),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.spacing),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.spacing),

            cancelButton.heightAnchor.constraint(equalToConstant: Layout.buttonSide),
            cancelButton.widthAnchor.constraint(equalToConstant: Layout.buttonSide),
            cancelButton.topAnchor.constraint(equalTo: topAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),

            speedStack.heightAnchor.constraint(equalToConstant: Const.speedStackHeight),
            speedStack.widthAnchor.constraint(equalToConstant: Const.speedStackWidth),
            speedStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            speedStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.spacing)
        ]
        .forEach { $0.isActive = true }

        backgroundColor = Palette.background
    }

    private func setupSubscription() {
        viewModel.setupViewStateUpdates()
            .store(in: &cancellablesBag)

        viewModel.viewState
            .sink { [weak self] viewState in
                guard let viewState else {
                    return
                }
                self?.distanceLeftLabel.text = viewState.distanceLeft
                self?.timeLeftLabel.text = viewState.timeLeft
                self?.flagsLabel.text = viewState.flags
                self?.roadLabel.text = viewState.road

                self?.simulationSpeedLabel.text = viewState.simulationSpeed
                self?.speedStack.isHidden = !viewState.isSimulationPanelVisible

                let currentSpeed = {
                    if let currentSpeed = viewState.speedState.current {
                        return String(currentSpeed.rounded())
                    } else {
                        return "undefined"
                    }
                }()

                let limitSpeed = {
                    if let limitSpeed = viewState.speedState.limit {
                        return String(limitSpeed.rounded())
                    } else {
                        return "undefined"
                    }
                }()

                let isLimitExceeded = viewState.speedState.isLimitExceeded

                self?.speedLabel.text = "Speed: \(currentSpeed) / \(limitSpeed)"
                self?.speedLabel.textColor = isLimitExceeded ? .red : .black
            }
            .store(in: &cancellablesBag)

        viewModel.setupGuidanceFinishedSubscription()
            .store(in: &cancellablesBag)
    }

    @objc
    private func handleCancelButtonTap() {
        viewModel.cancel()
    }

    @objc
    private func handleSimulationSpeedMinusButtonTap() {
        viewModel.changeSimulationSpeed(by: -1.0)
    }

    @objc
    private func handleSimulationSpeedPlusButtonTap() {
        viewModel.changeSimulationSpeed(by: 1.0)
    }

    // MARK: - Private properties

    private let viewModel: GuidanceViewModel

    private let distanceLeftLabel = UILabel()
    private let timeLeftLabel = UILabel()
    private let flagsLabel = UILabel()
    private let roadLabel = UILabel()
    private let speedLabel = UILabel()

    private let cancelButton = UIButton()
    private let simulationSpeedLabel = UILabel()
    private var speedStack = UIStackView()

    private var cancellablesBag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {
        static let height: CGFloat = 180.0
        static let spacing: CGFloat = 20.0
        static let speedStackWidth: CGFloat = 100.0
        static let speedStackHeight: CGFloat = 50.0
    }
}
