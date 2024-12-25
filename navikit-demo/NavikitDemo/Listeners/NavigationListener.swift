//
//  NavigationListener.swift
//

import YandexMapsMobile

final class NavigationListener: NSObject, YMKNavigationListener {
    func onRoutesRequested(with points: [YMKRequestPoint]) {
    }

    func onAlternativesRequested(withCurrentRoute currentRoute: YMKDrivingRoute) {
    }

    func onUriResolvingRequested(withUri uri: String) {
    }

    func onMatchRouteResolvingRequested() {
    }

    func onParkingRoutesRequested() {
    }

    func onRoutesBuilt() {
    }

    func onRoutesRequestErrorWithError(_ error: Error) {
    }

    func onResetRoutes() {
    }
}
