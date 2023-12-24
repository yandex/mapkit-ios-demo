//
//  ClusterView.swift
//  MapObjects
//

import UIKit
import YandexMapsMobile

final class ClusterView: UIView {
    init(placemarks: [PlacemarkUserData]) {
        self.placemarks = placemarks
        super.init(frame: .zero)

        setNeedsLayout()
        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    override func layoutSubviews() {
        backgroundColor = Palette.background
        layer.cornerRadius = Layout.cornerRadius
        isOpaque = false

        let typesCount = PlacemarkType.allCases
            .map { type in
                let count = placemarks.reduce(.zero) { partialResult, userData in
                    partialResult + (userData.type == type ? 1 : 0)
                }
                return (type: type, count: count)
            }
            .filter { $0.count > 0 }

        var xCoordinate = Layout.bigSpacing
        let yCoordinate = Layout.smallSpacing

        for element in typesCount {
            let image = element.type.image
            let count = element.count

            let imageView = UIImageView(image: image)
            addSubview(imageView)

            imageView.contentMode = .scaleAspectFit
            imageView.frame.size = CGSize(width: Layout.pinViewSize, height: Layout.pinViewSize)
            imageView.frame.origin = CGPoint(x: xCoordinate, y: yCoordinate)

            xCoordinate += imageView.frame.width + Layout.smallSpacing

            let labelView = UILabel()
            addSubview(labelView)

            labelView.numberOfLines = 0
            labelView.text = String(count)
            labelView.textColor = .darkGray

            labelView.sizeToFit()

            labelView.frame.size.height = Layout.pinViewSize
            labelView.frame.origin = CGPoint(x: xCoordinate, y: yCoordinate)

            xCoordinate += labelView.frame.width + Layout.bigSpacing
        }

        frame.size = CGSize(width: xCoordinate, height: Layout.pinViewSize + Layout.smallSpacing * 2)
    }

    // MARK: - Private properties

    private let placemarks: [PlacemarkUserData]

    // MARK: - Private nesting

    private enum Layout {
        static let bigSpacing: CGFloat = 4.0
        static let smallSpacing: CGFloat = 2.0
        static let pinViewSize: CGFloat = 16.0
        static let cornerRadius: CGFloat = 10.0
    }
}
