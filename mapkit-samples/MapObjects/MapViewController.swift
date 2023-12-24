//
//  MapViewController.swift
//  MapObjects
//

import UIKit
import YandexMapsMobile

class MapViewController: UIViewController {
    // MARK: - Public methods

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = YMKMapView(frame: view.frame)
        view.addSubview(mapView)

        map = mapView.mapWindow.map

        mapView.mapWindow.addSizeChangedListener(with: mapSizeChangedListener)
        updateMapFocus()

        map.move(with: GeometryProvider.startPosition)

        pinsCollection = map.mapObjects.add()
        clusterizedCollection = pinsCollection.addClusterizedPlacemarkCollection(with: clusterListener)

        polygonMapObject = pinsCollection.addPolygon(with: GeometryProvider.polygon)
        polygonMapObject.strokeWidth = 1.5
        polygonMapObject.strokeColor = Palette.olive
        polygonMapObject.fillColor = Palette.oliveTransparent

        polylineMapObject = pinsCollection.addPolyline(with: GeometryProvider.polyline)
        polylineMapObject.strokeWidth = 5.0
        polylineMapObject.setStrokeColorWith(.gray)
        polylineMapObject.outlineWidth = 1.0
        polylineMapObject.outlineColor = .black
        polylineMapObject.addTapListener(with: mapObjectTapListener)

        let circle = pinsCollection.addCircle(with: GeometryProvider.circleWithRandomRadius)
        circle.strokeColor = Palette.red
        circle.strokeWidth = 2.0
        circle.fillColor = Palette.redTransparent
        circle.addTapListener(with: mapObjectTapListener)

        addClusterizablePlacemarks()
        addPlacemarks()

        setupSubviews()
    }

    // MARK: - Private methods

    /// Sets the map to specified point, zoom, azimuth and tilt
    private func move(_ map: YMKMap, to cameraPosition: YMKCameraPosition = GeometryProvider.startPosition) {
        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }

    /// Sets the map to specified geometry
    private func move(_ map: YMKMap, to geometry: YMKGeometry) {
        let cameraPosition = map.cameraPosition(with: geometry)

        map.move(with: cameraPosition, animation: YMKAnimation(type: .smooth, duration: 1.0))
    }

    private func addClusterizablePlacemarks() {
        let iconStyle = YMKIconStyle()
        iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 0.5))
        iconStyle.scale = 0.6

        GeometryProvider.clusterizedPoints.enumerated().forEach { pair in
            let index = pair.offset
            let point = pair.element

            let type = PlacemarkType.random
            let image = type.image

            let placemark = clusterizedCollection.addPlacemark()
            placemark.geometry = point
            placemark.setIconWith(image, style: iconStyle)

            placemark.isDraggable = true
            placemark.setDragListenerWith(mapObjectDragListener)
            placemark.userData = PlacemarkUserData(name: "Data_\(index)", type: type)
            placemark.addTapListener(with: mapObjectTapListener)
        }

        clusterizedCollection.clusterPlacemarks(
            withClusterRadius: GeometryProvider.clusterRadius,
            minZoom: GeometryProvider.clusterMinZoom
        )
    }

    private func addPlacemarks() {
        let placemark = pinsCollection.addPlacemark()
        placemark.geometry = GeometryProvider.compositeIconPoint
        placemark.addTapListener(with: singlePlacemarkTapListener)
        placemark.setTextWithText(
            "Special place",
            style: {
                let textStyle = YMKTextStyle()
                textStyle.size = 10.0
                textStyle.placement = .right
                textStyle.offset = 5.0
                return textStyle
            }()
        )

        let compositeIcon = placemark.useCompositeIcon()
        compositeIcon.setIconWithName(
            "pin",
            image: UIImage(named: "icon_dollar")!,
            style: {
                let iconStyle = YMKIconStyle()
                iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 1.0))
                iconStyle.scale = 0.9
                return iconStyle
            }()
        )
        compositeIcon.setIconWithName(
            "point",
            image: UIImage(named: "icon_circle")!,
            style: {
                let iconStyle = YMKIconStyle()
                iconStyle.anchor = NSValue(cgPoint: CGPoint(x: 0.5, y: 0.5))
                iconStyle.scale = 0.5
                iconStyle.flat = true
                return iconStyle
            }()
        )

        if let animatedImageProvider = YRTAnimatedImageProviderFactory.fromFile(
            Bundle.main.path(forResource: "animation", ofType: "png")
        ) as? YRTAnimatedImageProvider {
            let animatedPlacemark = pinsCollection.addPlacemark()

            animatedPlacemark.geometry = GeometryProvider.animatedImagePoint

            let iconStyle = YMKIconStyle()
            iconStyle.scale = 0.6

            animatedPlacemark.useAnimation().setIconWithImage(animatedImageProvider, style: iconStyle)
            animatedPlacemark.useAnimation().play()
        }
    }

    /// Updates map focus
    private func updateMapFocus() {
        let scale = Float(UIScreen.main.scale)

        mapView.mapWindow.focusRect = YMKScreenRect(
            topLeft: YMKScreenPoint(x: Float(Layout.horizontalMargin) * scale, y: Float(Layout.verticalMargin) * scale),
            bottomRight: YMKScreenPoint(
                x: Float(view.frame.width - Layout.horizontalMargin) * scale,
                y: Float(view.frame.height - Layout.verticalMargin) * scale
            )
        )
    }

    // MARK: - Private properties

    private var mapView: YMKMapView!
    private lazy var map: YMKMap = mapView.mapWindow.map
    private var pinsCollection: YMKMapObjectCollection!
    private var clusterizedCollection: YMKClusterizedPlacemarkCollection!
    private var polygonMapObject: YMKPolygonMapObject!
    private var polylineMapObject: YMKPolylineMapObject!

    private lazy var mapSizeChangedListener = MapSizeChangedListener { [weak self] in
        self?.updateMapFocus()
    }

    private lazy var mapObjectTapListener = MapObjectTapListener(controller: self)

    private lazy var singlePlacemarkTapListener = PlacemarkMapObjectTapListener(
        controller: self,
        alertTitle: "Tapped the placemark with composite icon"
    )

    private lazy var animatedPlacemarkTapListener = PlacemarkMapObjectTapListener(
        controller: self,
        alertTitle: "Tapped the animated placemark"
    )

    private lazy var mapObjectDragListener = MapObjectDragListener(
        controller: self,
        clusterizedCollection: clusterizedCollection
    )

    private lazy var clusterListener = ClusterListener(controller: self)

    private lazy var geometryVisitorViewModel = GeometryVisitorViewModel()
    private lazy var geometryVisibilityVisitor = GeometryVisibilityVisitor(viewModel: geometryVisitorViewModel)

    // MARK: - Layout

    private enum Layout {
        static let horizontalMargin: CGFloat = 40.0
        static let verticalMargin: CGFloat = 60.0

        static let buttonSize: CGFloat = 50.0
        static let buttonCornerRadius: CGFloat = 8.0
    }

    private func setupSubviews() {
        view.addSubview(toolbarView)
        toolbarView.axis = .horizontal
        toolbarView.alignment = .fill
        toolbarView.distribution = .equalSpacing
        toolbarView.translatesAutoresizingMaskIntoConstraints = false

        [
            toolbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.horizontalMargin),
            toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.horizontalMargin),
            toolbarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.verticalMargin)
        ]
        .forEach { $0.isActive = true }

        [changeCollectionVisibilityButton, focusPolylineButton, focusPolygonButton, changeGeometryVisibilityButton]
            .forEach {
                toolbarView.addArrangedSubview($0)

                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.layer.cornerRadius = Layout.buttonCornerRadius

                [
                    $0.heightAnchor.constraint(equalToConstant: Layout.buttonSize),
                    $0.widthAnchor.constraint(equalToConstant: Layout.buttonSize)
                ]
                .forEach { $0.isActive = true }

                $0.backgroundColor = Palette.background
            }

        changeCollectionVisibilityButton.setImage(UIImage(systemName: "mappin.slash.circle.fill"), for: .normal)
        focusPolygonButton.setImage(UIImage(systemName: "hexagon"), for: .normal)
        focusPolylineButton.setImage(UIImage(systemName: "square.split.diagonal.2x2"), for: .normal)
        changeGeometryVisibilityButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)

        changeCollectionVisibilityButton.addTarget(
            self,
            action: #selector(changeCollectionVisibilityButtonTapHandler),
            for: .touchUpInside
        )
        focusPolygonButton.addTarget(
            self,
            action: #selector(focusPolygonButtonTapHandler),
            for: .touchUpInside
        )
        focusPolylineButton.addTarget(
            self,
            action: #selector(focusPolylineButtonTapHandler),
            for: .touchUpInside
        )
        changeGeometryVisibilityButton.addTarget(
            self,
            action: #selector(changeGeometryVisibilityButtonTapHandler),
            for: .touchUpInside
        )
    }

    @objc
    private func changeCollectionVisibilityButtonTapHandler() {
        AlertPresenter.present(from: self, with: "\(pinsCollection.isVisible ? "Hiding" : "Showing") all objects")
        pinsCollection.isVisible.toggle()
    }

    @objc
    private func focusPolygonButtonTapHandler() {
        let geometry = YMKGeometry(polygon: polygonMapObject.geometry)
        move(map, to: geometry)
    }

    @objc
    private func focusPolylineButtonTapHandler() {
        let geometry = YMKGeometry(polyline: polylineMapObject.geometry)
        move(map, to: geometry)
    }

    @objc
    private func changeGeometryVisibilityButtonTapHandler() {
        AlertPresenter.present(
            from: self,
            with: "Turning geometry \(geometryVisitorViewModel.isGeometryShownOnMap ? "off" : "on")"
        )
        geometryVisitorViewModel.isGeometryShownOnMap.toggle()
        pinsCollection.traverse(with: geometryVisibilityVisitor)
    }

    private let toolbarView = UIStackView()
    private let changeCollectionVisibilityButton = UIButton()
    private let focusPolygonButton = UIButton()
    private let focusPolylineButton = UIButton()
    private let changeGeometryVisibilityButton = UIButton()
}
