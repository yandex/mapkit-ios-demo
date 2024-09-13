//
//  RoutesVariantsBannerView.swift

//

import UIKit

final class RoutesVariantsBannerView: UIView {
    // MARK: - Constructor

    init(routingManager: RoutingManager, mapViewStateManager: MapViewStateManager) {
        self.routingManager = routingManager
        self.mapViewStateManager = mapViewStateManager

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubviews() {
        let label = UILabel()
        let cancelButton = UIButton()
        let startButton = UIButton()
        let buttonsStack = UIStackView(arrangedSubviews: [cancelButton, startButton])
        let stack = UIStackView(arrangedSubviews: [label, buttonsStack])

        label.text = "Choose route"
        label.textColor = .black
        label.textAlignment = .center

        cancelButton.setTitle("Cancel", for: .normal)
        startButton.setTitle("Start", for: .normal)

        [cancelButton, startButton]
            .forEach {
                $0.setTitleColor(tintColor, for: .normal)
                $0.backgroundColor = Palette.background
                $0.layer.cornerRadius = Layout.cornerRadius
            }

        cancelButton.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(handleStartButtonTap), for: .touchUpInside)

        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .equalSpacing

        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing

        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false

        [
            heightAnchor.constraint(equalToConstant: Const.height),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: Const.spacing),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Const.spacing),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.spacing),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.spacing),

            buttonsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.spacing),
            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.spacing),

            label.heightAnchor.constraint(equalToConstant: Layout.buttonSide),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),

            cancelButton.heightAnchor.constraint(equalToConstant: Layout.buttonSide),
            cancelButton.widthAnchor.constraint(equalToConstant: Layout.buttonLargeSide),
            startButton.heightAnchor.constraint(equalToConstant: Layout.buttonSide),
            startButton.widthAnchor.constraint(equalToConstant: Layout.buttonLargeSide)
        ]
        .forEach { $0.isActive = true }

        backgroundColor = Palette.background
    }

    @objc
    private func handleCancelButtonTap() {
        mapViewStateManager.set(state: .map)
    }

    @objc
    private func handleStartButtonTap() {
        mapViewStateManager.set(state: .guidance)
    }

    // MARK: - Private properties

    private let routingManager: RoutingManager
    private let mapViewStateManager: MapViewStateManager

    // MARK: - Private nesting

    private enum Const {
        static let height: CGFloat = 150.0
        static let spacing: CGFloat = 20.0
    }
}
