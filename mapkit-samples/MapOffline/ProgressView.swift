import UIKit

final class ProgressView: UIView {

    // MARK: - Private Properties

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Private Methods

    private func commonInit() {
        setupView()
    }

    private func setupView() {
        backgroundColor = .lightGray
    }

    // MARK: - Public Methods

    func configureView(value: Float) {
        layer.sublayers?.removeAll()

        let myLayer = CALayer()
        myLayer.frame = CGRect(x: 0, y: 0, width: CGFloat(value) * frame.size.width, height: 6)
        myLayer.backgroundColor = UIColor.darkGray.cgColor
        layer.addSublayer(myLayer)
    }
}
