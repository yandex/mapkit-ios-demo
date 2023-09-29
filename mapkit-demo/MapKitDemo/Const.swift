import YandexMapsMobile

enum Const {
	static let clusterCenters: [YMKPoint] = [
        YMKPoint(latitude: 55.756, longitude: 37.618),
        YMKPoint(latitude: 59.956, longitude: 30.313),
        YMKPoint(latitude: 56.838, longitude: 60.597),
        YMKPoint(latitude: 43.117, longitude: 131.900),
        YMKPoint(latitude: 56.852, longitude: 53.204)
    ]

	static let targetLocation = YMKPoint(latitude: 59.945933, longitude: 30.320045)

	static let routeStartPoint = YMKPoint(latitude: 59.959194, longitude: 30.407094)
    static let routeEndPoint = YMKPoint(latitude: 55.733330, longitude: 37.587649)

    static let animatedRectangleCenter = YMKPoint(latitude: 59.956, longitude: 30.313)
    static let triangleCenter = YMKPoint(latitude: 59.948, longitude: 30.313)
    static let circleCenter = YMKPoint(latitude: 59.956, longitude: 30.323)
    static let draggablePlacemarkCenter = YMKPoint(latitude: 59.948, longitude: 30.323)
    static let animatedPlacemarkCenter = YMKPoint(latitude: 59.948, longitude: 30.318)

	static let coloredPolylinePoints = [
		YMKPoint(latitude: 59.949941, longitude: 30.310250),
		YMKPoint(latitude: 59.950867, longitude: 30.313382),
		YMKPoint(latitude: 59.949596, longitude: 30.315056),
		YMKPoint(latitude: 59.951103, longitude:  30.321622)
    ]

	static let boundingBox = YMKBoundingBox(
        southWest: YMKPoint(latitude: 55.55, longitude: 37.42),
        northEast: YMKPoint(latitude: 55.95, longitude: 37.82))

	static let logoURL = "https://maps-ios-pods-public.s3.yandex.net/mapkit_logo.png"
}
