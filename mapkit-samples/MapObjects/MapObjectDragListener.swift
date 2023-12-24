//
//  MapObjectDragListener.swift
//  MapObjects
//

import UIKit
import YandexMapsMobile

final class MapObjectDragListener: NSObject, YMKMapObjectDragListener {
    // MARK: - Constructor

    init(controller: UIViewController, clusterizedCollection: YMKClusterizedPlacemarkCollection) {
        self.controller = controller
        self.clusterizedCollection = clusterizedCollection
    }

    // MARK: - Public methods

    func onMapObjectDragStart(with mapObject: YMKMapObject) {
        AlertPresenter.present(from: controller, with: "Drag event started")
    }

    func onMapObjectDrag(with mapObject: YMKMapObject, point: YMKPoint) {}

    func onMapObjectDragEnd(with mapObject: YMKMapObject) {
        AlertPresenter.present(from: controller, with: "Drag event ended")

        clusterizedCollection.clusterPlacemarks(
            withClusterRadius: GeometryProvider.clusterRadius,
            minZoom: GeometryProvider.clusterMinZoom
        )
    }

    // MARK: - Private properties

    private weak var controller: UIViewController?
    private var clusterizedCollection: YMKClusterizedPlacemarkCollection
}
