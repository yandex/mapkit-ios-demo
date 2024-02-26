//
//  CameraManager.swift
//

import YandexMapsMobile

protocol CameraManager {
    // MARK: - Public properties

    var cameraMode: YMKCameraMode { get set }

    // MARK: - Public methods

    func changeZoom(_ change: ZoomChange)
    func moveCameraToUserLocation()
    func start()
}
