import Core
import UIComponent

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NMapsMap

import Domain

public final class LottyMapViewController: BaseViewController {
    
    private weak var builder: MapFeatureBuilder?
    private let viewModel: LotteryMapViewModel
    
    private lazy var mapView = NMFMapView()
    private lazy var searchBar = StoreSearchBar()
    private lazy var refreshButton = UIButton()
    private lazy var currentLocationButton = UIButton()
    private lazy var storeToastView = StoreToastView()
    
    private let onChangeCameraPosition = PublishRelay<CLLocationCoordinate2D>()
    private var markersInMap: [LottyMarker?] = []
    
    private var selectedStore = SelectedStore()
    
    struct SelectedStore {
        weak var marker: LottyMarker?
        var data: StoreModel?
        var latitude, longitude: Double?
        
        mutating func set(marker: LottyMarker?, data: StoreModel) {
            self.marker = marker
            self.marker?.isSelected = true
            self.marker?.zIndex = 1
            self.data = data
            self.latitude = Double(data.y)
            self.longitude = Double(data.x)
        }
        
        mutating func reset() {
            self.marker?.isSelected = false
            self.marker?.zIndex = 0
            self.marker = nil
            self.data = nil
            self.latitude = nil
            self.longitude = nil
        }
    }
    
    public init(builder: MapFeatureBuilder, viewModel: LotteryMapViewModel) {
        self.builder = builder
        self.viewModel = viewModel
        super.init()
    }
    
    deinit {
        mapView.removeLoadDelegate(delegate: self)
        mapView.removeCameraDelegate(delegate: self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    private func bindViewModel() {
        let input = LotteryMapViewModel.Input(
            viewDidLoad: Observable.just(()),
            cameraPositionDidChange: onChangeCameraPosition.asObservable(),
            refreshButtonDidTap: refreshButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input)
        
        searchBar.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                HapticManager.run()
                
                guard let storeSearchViewController = owner.builder?.buildStoreSearchVC() else { return }
                storeSearchViewController.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(storeSearchViewController, animated: true)
            }.disposed(by: bag)
        
        refreshButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.refreshButton.isHidden = true
                self?.refreshButton.isUserInteractionEnabled = false
                self?.selectedStore.reset()
                self?.hideStoreToast()
            }.disposed(by: bag)
        
        currentLocationButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                HapticManager.run()
                owner.scrollTo(x: LocationManager.shared.longitude, y: LocationManager.shared.latitude)
            }.disposed(by: bag)
        
        output.storeSearchResult
            .asDriver(onErrorJustReturn: nil)
            .drive { [weak self] store in
                guard let store else { return }
                self?.refreshButton.isHidden = true
                self?.refreshButton.isUserInteractionEnabled = false
                
                self?.selectedStore.reset()
                self?.selectedStore.set(marker: nil, data: store)
                
                self?.scrollTo(x: Double(store.x)!, y: Double(store.y)!)
                self?.viewModel.requestStoreList(x: Double(store.x)!, y: Double(store.y)!)
                self?.storeToastView.bind(store: store)
                self?.showStoreToast()
            }.disposed(by: bag)
        
        output.storeList
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] storeList in
                self?.makeShopMarkers(storeList: storeList)
            }.disposed(by: bag)
        
        output.userLocation
            .withUnretained(self)
            .bind { owner, _ in
                owner.refreshButton.isHidden = false
                owner.refreshButton.isUserInteractionEnabled = true
            }.disposed(by: bag)
    }
    
    private func showStoreToast() {
        storeToastView.isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.currentLocationButton.transform = CGAffineTransform(translationX: 0, y: -120)
                self.storeToastView.transform = CGAffineTransform(translationX: 0, y: -120)
                self.storeToastView.alpha = 1
            }
        )
    }
    
    private func hideStoreToast() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            animations: {
                self.currentLocationButton.transform = CGAffineTransform(translationX: 0, y: 0)
                self.storeToastView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.storeToastView.alpha = 0
            }
        )
    }
    
    public override func setUIProperty() {
        mapView = {
            let mapView = NMFMapView()
            mapView.allowsRotating = false
            mapView.allowsTilting = false
            mapView.positionMode = .normal
            mapView.minZoomLevel = 10.0
            mapView.maxZoomLevel = 18.0
            mapView.extent = NMGLatLngBounds(
                southWestLat: 31.43,
                southWestLng: 122.37,
                northEastLat: 44.35,
                northEastLng: 131
            )
            mapView.latitude = LocationManager.shared.latitude
            mapView.longitude = LocationManager.shared.longitude
            mapView.zoomLevel = 16.0
            mapView.addLoadDelegate(delegate: self)
            mapView.addCameraDelegate(delegate: self)
            mapView.touchDelegate = self
            return mapView
        }()
        
        refreshButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.layer.cornerRadius = 16.0
            button.applyShadow(y: 0.5)
            button.configuration = .plain()
            
            let title = NSAttributedString(string: "현 지도에서 검색", attributes: [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)])
            button.configuration?.attributedTitle = AttributedString(title)
            
            button.configuration?.image = .init(systemName: "arrow.clockwise")
            button.configuration?.imagePadding = 4
            button.configuration?.preferredSymbolConfigurationForImage = .init(font: .systemFont(ofSize: 12.0))
            return button
        }()
        
        currentLocationButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.setImage(.init(systemName: "dot.scope"), for: .normal)
            button.layer.cornerRadius = 50 / 2
            button.applyShadow(y: 0.5)
            return button
        }()
        
        storeToastView.alpha = 0
    }
    
    public override func setLayout() {
        view.addSubviews(mapView, searchBar, refreshButton, currentLocationButton, storeToastView)
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.top.equalTo(safeArea).inset(8)
            make.height.equalTo(56)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom).offset(16)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeArea).inset(20)
            make.width.height.equalTo(50)
        }
        
        storeToastView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.bottom.equalTo(safeArea).offset(100)
            make.height.equalTo(100)
        }
    }
    
}


extension LottyMapViewController: NMFMapViewLoadDelegate, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate {
    
    public func mapViewDidFinishLoadingMap(_ mapView: NMFMapView) {
        scrollTo(x: LocationManager.shared.longitude, y: LocationManager.shared.latitude)
        
        refreshButton.isHidden = true
        refreshButton.isUserInteractionEnabled = false
        viewModel.requestStoreList()
    }
    
    public func mapViewCameraIdle(_ mapView: NMFMapView) {
        let position = mapView.cameraPosition.target
        
        onChangeCameraPosition.accept(.init(
            latitude: position.lat.rounded(),
            longitude: position.lng.rounded()
        ))
    }
    
    public func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        selectedStore.reset()
        hideStoreToast()
    }
        
    private func makeShopMarkers(storeList: [StoreModel]) {
        clearMarkers()
        
        for store in storeList {
            guard let latitude = Double(store.y), let longitude = Double(store.x) else { continue }
            
            let marker = LottyMarker()
            marker.position = .init(lat: latitude, lng: longitude)
            
            let isSelected = selectedStore.data?.address == store.address && selectedStore.data?.storeName == store.storeName
            
            marker.touchHandler = { [weak self] _ -> Bool in
                self?.selectedStore.reset()
                self?.selectedStore.set(marker: marker, data: store)
                
                self?.storeToastView.bind(store: store)
                self?.showStoreToast()
                return true
            }
            
            if isSelected {
                selectedStore.marker = marker
                marker.isSelected = true
            }
            
            DispatchQueue.main.async { [weak self, weak marker] in
                self?.markersInMap.append(marker)
                marker?.mapView = self?.mapView
            }
        }
    }
    
    private func clearMarkers() {
        DispatchQueue.main.async {
            self.markersInMap.forEach { $0?.mapView = nil }
            self.markersInMap.removeAll()
        }
    }
    
    func scrollTo(x: Double, y: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: .init(lat: y, lng: x), zoomTo: 16.0)
        mapView.moveCamera(cameraUpdate)
    }
    
}
