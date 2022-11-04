import UIKit
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation

final class AroundViewController: UIViewController, CLLocationManagerDelegate {
    
    struct SelectedShop {
        weak var marker: NMFMarker?
        var data: Documents?
        var lat: String?
        var lng: String?
        
        mutating func save(marker: NMFMarker?, data: Documents?) {
            self.marker = marker
            self.data = data
            self.lat = data?.y
            self.lng = data?.x
        }
        
        mutating func reset() {
            self.marker = nil
            self.data = nil
            self.lat = data?.y
            self.lng = data?.x
        }
    }
    
    var naverMapView: NMFMapView?
    let searchBar = SearchBarView()
    let detailView = StoreDetailView()
    
    var currentLocationButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    let blockView = UIView()
    let alertView = AlertView()
    
    var locationManager = CLLocationManager()
    
    let viewModel = AroundViewModel()
    let disposeBag = DisposeBag()
    
    let markerBase = LottyMapMarker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var markersInMap: [NMFMarker?] = []
    
    var selectedShop = SelectedShop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        configureMap()
        inputBind()
        outputBind()
    }
    
    func inputBind() {
        
    }
    
    func outputBind() {
        viewModel.storeInfoRelay
            .withUnretained(self).map { $0.0 }
            .bind(onNext: {
                
            }).disposed(by: disposeBag)
    }
    
    func configureMap() {
        guard naverMapView != nil else { return }
        self.tabBarController?.tabBar.backgroundColor = .white
        
        naverMapView!.addCameraDelegate(delegate: self)
        naverMapView!.touchDelegate = self
        naverMapView!.allowsRotating = false
        naverMapView!.allowsTilting = false
        naverMapView!.minZoomLevel = 5
        naverMapView!.positionMode = .compass
        naverMapView!.extent = NMGLatLngBounds(southWestLat: 31.43,
                                      southWestLng: 122.37,
                                      northEastLat: 44.35,
                                      northEastLng: 131)
        let location = locationManager.location ?? CLLocation(latitude: 37.3593486, longitude: 127.104845)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: location.coordinate), zoomTo: 16)
        naverMapView!.moveCamera(cameraUpdate)
        
        configureNavi()
    }
    
    // MARK: - Draw
    private func deleteOldMarkers() {
        guard naverMapView != nil else { return }
        let markerList = viewModel.storeInfoRelay.value
        
        DispatchQueue.main.async { [weak self] in
            self?.markersInMap.forEach { $0?.mapView = nil }
            self?.markersInMap.removeAll()
            if markerList.count == 0 {
                self?.selectedShop.marker = nil
            }
        }
    }
    
    private func makeShopMarkers() {
        let value = viewModel.storeInfoRelay.value
        
        deleteOldMarkers()
        value.forEach { [weak self] shopData in
            let marker = (self?.markerBase)!
            self?.drawShopMarkerInMap(markerInfo: shopData, shopMarker: marker)
        }
        
    }
    
    func drawShopMarkerInMap(markerInfo: Documents, shopMarker: LottyMapMarker) {
        guard let lat = Double(markerInfo.y),
              let lng = Double(markerInfo.x) else { return }
        
        let position = NMGLatLng(lat: lat, lng: lng)
        let marker = NMFMarker(position: position)
        let isSelected = (selectedShop.lat == markerInfo.y && selectedShop.lng == markerInfo.x)
        
        marker.touchHandler = { [weak self] touchMarker -> Bool in
            self?.switchShopSelectedMarker(isNew: false)
            self?.selectedShop.save(marker: marker, data: markerInfo)
            self?.switchShopSelectedMarker(isNew: true)
            self?.setShopDetail(markerInfo: markerInfo)
            return true
        }
        
        DispatchQueue.main.async { [weak self] in
            if isSelected {
                self?.switchShopSelectedMarker(isNew: false)
                self?.selectedShop.save(marker: marker, data: markerInfo)
                self?.switchShopSelectedMarker(isNew: true)
            } else {
                shopMarker.isPressed = isSelected
//                shopMarker.setData(markerInfo: markerInfo)
                marker.iconImage = NMFOverlayImage(image: shopMarker.asImage())
            }
            
            marker.mapView = self?.naverMapView
            self?.markersInMap.append(marker)
        }
    }
    
    func switchShopSelectedMarker(isNew : Bool) {
        guard let marker = selectedShop.marker,
              let shopData = selectedShop.data else { return }

        let shopMarker = self.markerBase
        shopMarker.isPressed = isNew
//        shopMarker.setData(markerInfo: shopData)
        marker.zIndex = isNew ? 1 : 0
        marker.iconImage = NMFOverlayImage(image: shopMarker.asImage())
        showShopView()
    }
    
    private func setShopDetail(markerInfo: Documents) {
        detailView.id = markerInfo.id
        detailView.lat = markerInfo.y
        detailView.lng = markerInfo.x
        
        detailView.storeName.text = markerInfo.place_name
        detailView.storeAddress.text = markerInfo.address_name
        detailView.storeCall.text = markerInfo.phone
    }
    
    private func showShopView() {
        detailView.isHidden = false
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.detailView.transform = CGAffineTransform(translationX: 0, y: -98)
            }
        )
        
    }
    
    private func hideShopView() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: { [weak self] in
                self?.detailView.transform = CGAffineTransform(translationX: 0, y: 0)
            },
            completion: { [weak self] _ in
                self?.detailView.isHidden = true
            }
        )
    }
    
    func configureDetail(store: Documents) {
        view.addSubview(detailView)
        detailView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        let naviTap = UITapGestureRecognizer(target: self, action: #selector(clickNavi))
        detailView.naviView.addGestureRecognizer(naviTap)
    }
    
    
    
    func configureButton() {
        view.addSubview(currentLocationButton)
        currentLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentLocationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        currentLocationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        currentLocationButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(clickLocationButton))
        currentLocationButton.addGestureRecognizer(locationTap)
    }
    
    @objc func clickLocationButton() {
        let location = locationManager.location ?? CLLocation(latitude: 37.3593486, longitude: 127.104845)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: location.coordinate), zoomTo: 16)
        cameraUpdate.animation = .none
        naverMapView!.moveCamera(cameraUpdate)
    }

}


// MARK: CAMERA별 판매점 마커 갱신
extension AroundViewController: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let coordinate = mapView.cameraPosition.target
        viewModel.updateCoordinate(x: coordinate.lng, y: coordinate.lat)
    }
 
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.switchShopSelectedMarker(isNew: false)
        self.selectedShop.reset()
        self.hideShopView()
    }
    
}

// MARK: 지도 검색 결과
extension AroundViewController: SearchDelegate {
    
    func mapSearch(query: String) {
        viewModel.searchAround(query: query)
    }
    
}
