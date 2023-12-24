//
//  GeometryVisibilityVisitor.swift
//  MapObjects
//

import YandexMapsMobile

final class GeometryVisibilityVisitor: NSObject, YMKMapObjectVisitor {
    // MARK: - Construtor

    init(viewModel: GeometryVisitorViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Public methods

    func onPlacemarkVisited(withPlacemark placemark: YMKPlacemarkMapObject) {}

    func onPolylineVisited(withPolyline polyline: YMKPolylineMapObject) {
        polyline.isVisible = viewModel.isGeometryShownOnMap
    }

    func onPolygonVisited(withPolygon polygon: YMKPolygonMapObject) {
        polygon.isVisible = viewModel.isGeometryShownOnMap
    }

    func onCircleVisited(withCircle circle: YMKCircleMapObject) {
        circle.isVisible = viewModel.isGeometryShownOnMap
    }

    func onCollectionVisitStart(with collection: YMKMapObjectCollection) -> Bool {
        true
    }

    func onCollectionVisitEnd(with collection: YMKMapObjectCollection) {}

    func onClusterizedCollectionVisitStart(with collection: YMKClusterizedPlacemarkCollection) -> Bool {
        true
    }

    func onClusterizedCollectionVisitEnd(with collection: YMKClusterizedPlacemarkCollection) {}

    // MARK: - Private properties

    private var viewModel: GeometryVisitorViewModel
}
