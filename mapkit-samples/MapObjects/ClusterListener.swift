//
//  ClusterListener.swift
//  MapObjects
//

import YandexMapsMobile

final class ClusterListener: NSObject, YMKClusterListener, YMKClusterTapListener {
    // MARK: - Constructor

    init(controller: UIViewController) {
        self.controller = controller
    }

    // MARK: - Public methods

    func onClusterTap(with cluster: YMKCluster) -> Bool {
        AlertPresenter.present(
            from: controller,
            with: "Tapped the cluster",
            message: "With \(cluster.size) items"
        )
        return true
    }

    func onClusterAdded(with cluster: YMKCluster) {
        let placemarks = cluster.placemarks.compactMap { $0.userData as? PlacemarkUserData }
        cluster.appearance.setViewWithView(YRTViewProvider(uiView: ClusterView(placemarks: placemarks)))
        cluster.addClusterTapListener(with: self)
    }

    // MARK: - Private properties

    private weak var controller: UIViewController?
}
