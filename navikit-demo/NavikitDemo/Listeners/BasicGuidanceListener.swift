//
//  BasicGuidanceListener.swift
//

import YandexMapsMobile

class BasicGuidanceListener: NSObject, YMKGuidanceListener {
    func onLocationChanged() {}

    func onCurrentRouteChanged(with reason: YMKRouteChangeReason) {}

    func onRouteLost() {}

    func onReturnedToRoute() {}

    func onRouteFinished() {}

    func onWayPointReached() {}

    func onStandingStatusChanged() {}

    func onRoadNameChanged() {}

    func onSpeedLimitUpdated() {}

    func onSpeedLimitStatusUpdated() {}

    func onAlternativesChanged() {}

    func onFastestAlternativeChanged() {}
}
