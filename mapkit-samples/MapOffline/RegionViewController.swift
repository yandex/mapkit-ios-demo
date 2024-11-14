//
//  MapViewController.swift
//  MapSearch
//

import Combine
import UIKit
import YandexMapsMobile

class RegionViewController: UIViewController {
    // MARK: - Public Properties

    // MARK: - Public methods

    convenience init(regionId: Int) {
        self.init()
        self.regionId = regionId
        regionViewModel.setRegion(with: regionId)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        offlineCacheRegionListener = OfflineCacheRegionListener(regionViewModel: regionViewModel)
        guard let offlineCacheRegionListener = offlineCacheRegionListener else { return }
        offlineManager.addRegionListener(with: offlineCacheRegionListener)
        regionViewModel.setupSubscriptions()

        setupRegionSubscriptions()
        setupSubviews()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let offlineCacheRegionListener = offlineCacheRegionListener else { return }
        self.offlineCacheRegionListener = nil
        offlineManager.removeRegionListener(with: offlineCacheRegionListener)
        bag.removeAll()
    }

    // MARK: - Private methods

    private func setupSubviews() {
        view.addSubview(regionView)
        regionView.axis = .vertical
        regionView.alignment = .fill
        regionView.spacing = 10
        regionView.translatesAutoresizingMaskIntoConstraints = false

        idLabel.textColor = .black
        idLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.numberOfLines = .zero
        countyLabel.textColor = .black
        citiesLabel.textColor = .black
        citiesLabel.numberOfLines = .zero
        parentIdLabel.textColor = .black
        centerLabel.textColor = .black

        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.layer.cornerRadius = 4
        showButton.setTitleColor(.black, for: .normal)
        showButton.contentMode = .scaleAspectFill
        showButton.backgroundColor = Palette.background

        downloadView.axis = .vertical
        downloadView.alignment = .fill
        downloadView.spacing = 10
        downloadView.translatesAutoresizingMaskIntoConstraints = false

        progressView.isHidden = true
        stateLabel.textColor = .black
        stateLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        sizeLabel.textColor = .black
        releaseLabel.textColor = .black
        downloadedTimeLabel.textColor = .black

        downloadButtonsView.axis = .horizontal
        downloadButtonsView.distribution = .fillEqually
        downloadButtonsView.spacing = 10
        downloadButtonsView.translatesAutoresizingMaskIntoConstraints = false

        [
            regionView.topAnchor.constraint(equalTo: view.topAnchor, constant: Layout.defaultInset),
            regionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.defaultInset)
        ]
        .forEach { $0.isActive = true }

        [idLabel, nameLabel, countyLabel, citiesLabel, parentIdLabel, centerLabel]
            .forEach {
                regionView.addArrangedSubview($0)
            }

        regionView.setCustomSpacing(25, after: parentIdLabel)

        view.addSubview(showButton)

        [
            showButton.leadingAnchor.constraint(equalTo: regionView.trailingAnchor, constant: Layout.defaultInset),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.defaultInset),
            showButton.centerYAnchor.constraint(equalTo: centerLabel.centerYAnchor),
            showButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            showButton.widthAnchor.constraint(equalToConstant: Layout.buttonWidth)
        ]
        .forEach { $0.isActive = true }

        view.addSubview(downloadView)

        [
            downloadView.topAnchor.constraint(equalTo: regionView.bottomAnchor, constant: Layout.downloadViewSpace),
            downloadView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.defaultInset),
            downloadView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.defaultInset)
        ]
        .forEach { $0.isActive = true }

        [stateLabel, downloadButtonsView, progressView, sizeLabel, releaseLabel, downloadedTimeLabel]
            .forEach {
                downloadView.addArrangedSubview($0)
            }

        [
            progressView.heightAnchor.constraint(equalToConstant: Layout.progressViewHeight)
        ]
        .forEach { $0.isActive = true }

        [startButton, stopButton, pauseButton, dropButton]
            .forEach {
                downloadButtonsView.addArrangedSubview($0)

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

        showButton.addTarget(
            self,
            action: #selector(showButtonTapHandler),
            for: .touchUpInside
        )

        startButton.addTarget(
            self,
            action: #selector(startButtonTapHandler),
            for: .touchUpInside
        )

        stopButton.addTarget(
            self,
            action: #selector(stopButtonTapHandler),
            for: .touchUpInside
        )

        pauseButton.addTarget(
            self,
            action: #selector(pauseButtonTapHandler),
            for: .touchUpInside
        )

        dropButton.addTarget(
            self,
            action: #selector(dropButtonTapHandler),
            for: .touchUpInside
        )
    }

    private func setupRegionSubscriptions() {
        regionViewModel.$region.sink { [weak self] regionInfo in
            guard let regionInfo = regionInfo else { return }
            self?.regionInfo = regionInfo
            self?.configureContentInfo()
        }
        .store(in: &bag)
    }

    private func configureContentInfo() {
        guard let regionInfo = regionInfo else { return }
        idLabel.text = "Id: \(regionInfo.id)"
        nameLabel.text = "Name: \(regionInfo.name)"
        countyLabel.text = "Country: \(regionInfo.country)"
        citiesLabel.text = "Cities: [\(regionInfo.cities)]"
        parentIdLabel.text = "Parent id: \(regionInfo.parentId)"
        centerLabel.text = "Center: (\(regionInfo.center))"
        stateLabel.text = "State: \(regionInfo.state)"
        sizeLabel.text = "Size: \(regionInfo.size)"
        releaseLabel.text = "Release time: \(regionInfo.realeseTime ?? "")"
        downloadedTimeLabel.text = "Downloaded time: \(regionInfo.downloadedReleaseTime ?? "")"

        progressView.configureView(value: regionInfo.downloadProgress)
        progressView.isHidden = regionInfo.state != "DOWNLOADING" && regionInfo.state != "PAUSED"

        showButton.setTitle("SHOW", for: .normal)
        startButton.setTitle("START", for: .normal)
        stopButton.setTitle("STOP", for: .normal)
        pauseButton.setTitle("PAUSE", for: .normal)
        dropButton.setTitle("DROP", for: .normal)
    }

    @objc
    private func showButtonTapHandler() {
        guard !isModalInPresentation else { return }
        dismiss(animated: true)
    }

    @objc
    private func startButtonTapHandler() {
        guard !offlineManager.mayBeOutOfAvailableSpace(withRegionId: UInt(regionId ?? .zero)) else { return }
        isModalInPresentation = true
        offlineManager.startDownload(withRegionId: UInt(regionId ?? .zero))
    }

    @objc
    private func stopButtonTapHandler() {
        isModalInPresentation = false
        offlineManager.stopDownload(withRegionId: UInt(regionId ?? .zero))
    }

    @objc
    private func pauseButtonTapHandler() {
        isModalInPresentation = false
        offlineManager.pauseDownload(withRegionId: UInt(regionId ?? .zero))
    }

    @objc
    private func dropButtonTapHandler() {
        isModalInPresentation = false
        offlineManager.drop(withRegionId: UInt(regionId ?? .zero))
    }

    // MARK: - Private properties

    private let regionView = UIStackView()
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let countyLabel = UILabel()
    private let citiesLabel = UILabel()
    private let parentIdLabel = UILabel()
    private let centerLabel = UILabel()
    private let showButton = UIButton()
    private let dividerView = UIView()
    private let downloadView = UIStackView()
    private let stateLabel = UILabel()
    private let downloadButtonsView = UIStackView()
    private let startButton = UIButton()
    private let stopButton = UIButton()
    private let pauseButton = UIButton()
    private let dropButton = UIButton()
    private let sizeLabel = UILabel()
    private let releaseLabel = UILabel()
    private let downloadedTimeLabel = UILabel()
    private let progressView = ProgressView()

    private let regionViewModel = RegionViewModel()

    private var regionInfo: RegionInfo?
    private var regionId: Int?

    private var offlineCacheRegionListener: OfflineCacheRegionListener?
    private lazy var offlineManager = YMKMapKit.sharedInstance().offlineCacheManager

    private var bag = Set<AnyCancellable>()

    // MARK: - Layout

    private enum Layout {
        static let buttonHeight: CGFloat = 36.0
        static let buttonWidth: CGFloat = 80.0
        static let defaultInset: CGFloat = 20.0
        static let downloadViewSpace: CGFloat = 60.0
        static let progressViewHeight = 6.0
    }
}
