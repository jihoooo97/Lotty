import UIKit
import RxSwift
import RxCocoa
import NMapsMap
import CoreLocation

final class AroundViewController: UIViewController {

    weak var coordinator: AroundCoordinator?
    private let viewModel: AroundViewModel
    private var disposeBag = DisposeBag()
    
    init(viewModel: AroundViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private struct SelectedShop {
        weak var marker: NMFMarker?
        var data: Store?
        var lat: String?
        var lng: String?
        
        mutating func save(marker: NMFMarker?, data: Store?) {
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
    
    private var naverMapView = LottyMapView()
    let searchBar = SearchBarView()
    let detailView = StoreDetailView()
    private var currentLocationButton = UIButton()
    let blockView = UIView()
    let alertView = AlertView()
    
    private var locationManager = CLLocationManager()
    
    private let markerBase = LottyMapMarker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private var markersInMap: [NMFMarker?] = []
    private var selectedShop = SelectedShop()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        initAttributes()
        initConstraints()
        configureMap()
        
        inputBind()
        outputBind()
    }
    
    
    private func inputBind() {
        searchBar.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { $0.coordinator?.pushAroundSearchViewController() }
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { $0.moveToCurrentLocation() }
            .disposed(by: disposeBag)
        
        detailView.naviButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self).map { $0.0 }
            .bind { $0.tapNaviButton() }
            .disposed(by: disposeBag)
    }
    
    private func outputBind() {
        // marker
        viewModel.storeListRelay
            .withUnretained(self).map { $0.0 }
            .bind { $0.makeShopMarkers() }
            .disposed(by: disposeBag)
        
        viewModel.searchResultRelay
            .withUnretained(self).map { $0 }
            .bind { vc, result in
                let cameraUpdate = NMFCameraUpdate(
                    scrollTo: NMGLatLng(lat: Double(result.y)!, lng: Double(result.x)!),
                    zoomTo: 16
                )
                vc.naverMapView.moveCamera(cameraUpdate)
            }
            .disposed(by: disposeBag)
        
        viewModel.noResultRelay
            .withUnretained(self)
            .bind { vc in
                AlertManager.shared.showAlert(
                    title: "안내", message: "검색 결과가 없습니다"
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func initAttributes() {
        currentLocationButton = UIButton().then {
            $0.setTitle("내위치", for: .normal)
            $0.setTitleColor(UIColor.red, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 15)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 4
            $0.layer.applyShadow(
                x: 0, y: 0.5, alpha: 0.4, blur: 2
            )
        }
    }
    
    private func initConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        [naverMapView, searchBar, currentLocationButton, detailView].forEach {
            view.addSubview($0)
        }
        
        naverMapView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalTo(safeArea)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.top.equalTo(safeArea).offset(4)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.width.equalTo(50)
            $0.height.equalTo(30)
        }
        
        detailView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.bottom.equalTo(safeArea).offset(90)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(90)
        }
    }
    
    private func configureMap() {
        naverMapView.addCameraDelegate(delegate: self)
        naverMapView.touchDelegate = self
        let location = locationManager.location ?? .init(latitude: 37.3593486, longitude: 127.104845)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(from: location.coordinate), zoomTo: 14)
        naverMapView.moveCamera(cameraUpdate)
    }
    
    // MARK: - Marker Draw
    private func deleteOldMarkers() {
        let markerList = viewModel.storeListRelay.value
        
        DispatchQueue.main.async { [weak self] in
            self?.markersInMap.forEach { $0?.mapView = nil }
            self?.markersInMap.removeAll()
            if markerList.count == 0 {
                self?.selectedShop.marker = nil
            }
        }
    }
    
    private func makeShopMarkers() {
        deleteOldMarkers()
        let value = viewModel.storeListRelay.value
        value.forEach { [weak self] store in
            let marker = (self?.markerBase)!
            self?.drawShopMarkerInMap(markerInfo: store, shopMarker: marker)
        }
    }
    
    private func drawShopMarkerInMap(markerInfo: Store, shopMarker: LottyMapMarker) {
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
                marker.iconImage = NMFOverlayImage(image: shopMarker.asImage())
            }
            
            marker.mapView = self?.naverMapView
            self?.markersInMap.append(marker)
        }
    }
    
    private func switchShopSelectedMarker(isNew : Bool) {
        guard let marker = selectedShop.marker else { return }
        
        let shopMarker = self.markerBase
        shopMarker.isPressed = isNew
        marker.zIndex = isNew ? 1 : 0
        marker.iconImage = NMFOverlayImage(image: shopMarker.asImage())
        showShopView()
    }
    
    // MARK: DetailView
    private func setShopDetail(markerInfo: Store) {
        detailView.bind(store: markerInfo)
    }
    
    private func showShopView() {
        detailView.isHidden = false
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.detailView.transform = CGAffineTransform(translationX: 0, y: -98)
            }
        )
    }
    
    private func hideShopView() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            animations: { [weak self] in
                self?.detailView.transform = CGAffineTransform(translationX: 0, y: 0)
            },
            completion: { [weak self] _ in
                self?.detailView.isHidden = true
            }
        )
    }
    
    private func tapNaviButton() {
        guard
            let x = locationManager.location?.coordinate.longitude,
            let y = locationManager.location?.coordinate.latitude
        else {
            // [!] Location 다시 받기
            return
        }
        
        if let lat = selectedShop.lat, let lng = selectedShop.lng {
            let url = "kakaomap://route?" + "ep=\(y),\(x)" + "&ep=\(lat),\(lng)" + "&by=CAR"
            
            if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                UIApplication.shared.open(openApp)
            } else {
                let downApp = URL(string: "https://apps.apple.com/us/app/id304608425")!
                UIApplication.shared.open(downApp)
            }
        }
    }
    
}


// MARK: CAMERA별 판매점 마커 갱신
extension AroundViewController: NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let coordinate = mapView.cameraPosition.target
        viewModel.updateCoordinate(x: coordinate.lng, y: coordinate.lat)
    }
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.switchShopSelectedMarker(isNew: false)
        self.selectedShop.reset()
        self.hideShopView()
    }
    
    private func moveToCurrentLocation() {
        guard let location = locationManager.location else {
            // [!] Location 다시 받기
            return
        }
        
        let camera = NMFCameraUpdate(scrollTo: NMGLatLng(from: location.coordinate), zoomTo: 14)
        camera.animation = .none
        naverMapView.moveCamera(camera)
    }
    
}

// MARK: 지도 검색 결과
extension AroundViewController: SearchDelegate {
    
    func mapSearch(keyword: String) {
        viewModel.searchAround(keyword: keyword)
    }
    
}
