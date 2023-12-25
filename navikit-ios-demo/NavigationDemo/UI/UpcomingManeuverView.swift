//
//  UpcomingManeuverView.swift
//  NavigationDemo
//
//  Created by Daniil Pustotin on 05.10.2023.
//

import Combine
import UIKit
import YandexMapsMobile
import YMKStylingAutomotiveNavigation
import YMKStylingRoadEvents

private enum LaneActionImageFactory {
    private enum Holder {
        static let unknown = UIImage(named: "other")!
        private static let forward = UIImage(named: "context_ra_forward")!
        private static let takeLeft = UIImage(named: "context_ra_take_left")!
        private static let takeRight = UIImage(named: "context_ra_take_right")!
        private static let turnLeft = UIImage(named: "context_ra_turn_left")!
        private static let turnRight = UIImage(named: "context_ra_turn_right")!
        private static let hardLeft = UIImage(named: "context_ra_hard_turn_left")!
        private static let hardRight = UIImage(named: "context_ra_hard_turn_right")!
        private static let forkLeft = takeLeft
        private static let forkRight = takeRight
        private static let uturnLeft = hardLeft
        private static let uturnRight = hardRight
        private static let circularIn = UIImage(named: "context_ra_in_circular_movement")!
        private static let circularOut = UIImage(named: "context_ra_out_circular_movement")!
        private static let boardFerry = UIImage(named: "context_ra_boardferry")!
        private static let leaveFerry = boardFerry
        private static let exitLeft = turnLeft
        private static let exitRight = turnRight
        private static let finish = UIImage(named: "context_ra_finish")!

        static let actionImages = [
            unknown,
            forward,
            takeLeft,
            takeRight,
            turnLeft,
            turnRight,
            hardLeft,
            hardRight,
            forkLeft,
            forkRight,
            uturnLeft,
            uturnRight,
            circularIn,
            circularOut,
            boardFerry,
            leaveFerry,
            exitLeft,
            exitRight,
            finish
        ]
    }

    static func make(for action: NSNumber) -> UIImage {
        guard Int(truncating: action) < Holder.actionImages.count else {
            return Holder.unknown
        }
        return Holder.actionImages[Int(truncating: action)]
    }
}

final class UpcomingManeuverView: UIView {
    // MARK: - Constructor

    init(viewModel: GuidanceViewModel) {
        self.viewModel = viewModel

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        setupSubscription()
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupSubviews() {
        updateStack()

        [
            distanceLabel,
            streetLabel
        ]
        .forEach {
            $0.textColor = .white
            $0.textAlignment = .natural
        }

        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Const.spacing / 2

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false

        [
            stack.topAnchor.constraint(equalTo: topAnchor, constant: Const.spacing),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Const.spacing),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Const.spacing),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Const.spacing)
        ]
        .forEach { $0.isActive = true }

        backgroundColor = Const.backgroundColor
        layer.cornerRadius = Layout.cornerRadius
    }

    private func updateStack() {
        [
            distanceLabel,
            laneSignImageView,
            actionImageView,
            streetLabel
        ]
        .forEach {
            stack.removeArrangedSubview($0)
        }

        stack.addArrangedSubview(distanceLabel)

        if laneSignImageView.image != nil {
            stack.addArrangedSubview(laneSignImageView)
        }
        if actionImageView.image != nil {
            stack.addArrangedSubview(actionImageView)
        }
        if !(streetLabel.text?.isEmpty ?? true) {
            stack.addArrangedSubview(streetLabel)
        }
    }

    private func setupSubscription() {
        viewModel.setupUpcomingManeuverUpdates()
            .store(in: &cancellablesBag)

        viewModel.upcomingManeuverViewState
            .sink { [weak self] viewState in
                guard let viewState else {
                    return
                }

                self?.distanceLabel.text = viewState.distance
                self?.streetLabel.text = viewState.nextStreet ?? ""
                if let laneSign = viewState.laneSign {
                    self?.laneSignImageView.image = self?.laneSignUIImage(laneSign)
                } else {
                    self?.laneSignImageView.image = nil
                }
                if let action = viewState.action {
                    self?.actionImageView.image = LaneActionImageFactory.make(for: action)
                } else {
                    self?.actionImageView.image = nil
                }

                self?.updateStack()
            }
            .store(in: &cancellablesBag)
    }

    private func laneSignUIImage(_ laneSign: YMKDrivingLaneSign) -> UIImage {
        let bitmap = UIImage()

        let size = CGSize(
            width: bitmap.size.width + 2 * Const.laneSignMargin,
            height: bitmap.size.height + 2 * Const.laneSignMargin
        )
        UIGraphicsBeginImageContext(size)
        Const.backgroundColor.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        bitmap.draw(at: CGPoint(x: Const.laneSignMargin, y: Const.laneSignMargin))
        let laneSignImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return laneSignImage
    }

    // MARK: - Private properties

    private let viewModel: GuidanceViewModel

    private let distanceLabel = UILabel()
    private let streetLabel = UILabel()
    private let laneSignImageView = UIImageView()
    private let actionImageView = UIImageView()
    private let stack = UIStackView()

    private var cancellablesBag = Set<AnyCancellable>()

    // MARK: - Private nesting

    private enum Const {
        static let height: CGFloat = 180.0
        static let spacing: CGFloat = 20.0
        static let laneSignMargin: CGFloat = 10.0
        static let backgroundColor = UIColor(red: 0.19, green: 0.39, blue: 0.96, alpha: 1.0)
    }
}
