import UIKit

protocol CheckBoxDelegate: AnyObject {
    func tapCheckbox(isChecked: Bool, type: CheckBox.CheckboxType)
}

class CheckBox: UIButton {

    enum CheckboxType {
        case cellularNetwork
        case autoEnabled
    }

    weak var delegate: CheckBoxDelegate?
    var type: CheckboxType?

    var isChecked: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.addTarget(self, action: #selector(toggleCheckBox), for: .touchUpInside)
        updateAppearance()
        self.backgroundColor = .clear
    }

    @objc private func toggleCheckBox() {
        isChecked.toggle()
    }

    private func updateAppearance() {
        if isChecked {
            self.setImage(UIImage(named: "check"), for: .normal)
        } else {
            self.setImage(UIImage(named: "uncheck"), for: .normal)
        }
        delegate?.tapCheckbox(isChecked: isChecked, type: type ?? .autoEnabled)
    }
}

class TitleCheckBoxView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        return checkBox
    }()

    init(title: String) {
        super.init(frame: .zero)
        setupView()
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(titleLabel)
        addSubview(checkBox)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBox.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            checkBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 30),
            checkBox.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
