import Core
import UIComponent
import BaseFeature

import UIKit
import SnapKit
import RxCocoa
import NMapsMap

public final class LottyMapViewController: BaseViewController {
    
    private lazy var mapView = NMFMapView()
    private lazy var searchBar = StoreSearchBar()
    private lazy var currentLocationButton = UIButton()
    
    public override init() {
        super.init()
    }
    
    deinit {
        mapView.removeCameraDelegate(delegate: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.requestAuthorization()
    }
    
    public override func setUIProperty() {
        mapView.addCameraDelegate(delegate: self)
        mapView.allowsRotating = false
        mapView.allowsTilting = false
        mapView.positionMode = .compass
        mapView.minZoomLevel = 10.0
        mapView.maxZoomLevel = 18.0
        mapView.extent = NMGLatLngBounds(
            southWestLat: 31.43,
            southWestLng: 122.37,
            northEastLat: 44.35,
            northEastLng: 131
        )
        mapView.latitude = LocationManager.shared.latitude //37.4
        mapView.longitude = LocationManager.shared.longitude //127.11
        
        searchBar.rx.tap
            .bind { [weak self] _ in
                self?.navigationController?.pushViewController(StoreSearchViewController(), animated: true)
            }.disposed(by: bag)
        
        currentLocationButton.backgroundColor = .white
        currentLocationButton.setImage(.init(systemName: "dot.scope"), for: .normal)
        currentLocationButton.layer.cornerRadius = 50 / 2
        currentLocationButton.applyShadow(x: 0, y: 0.5, alpha: 0.4, blur: 2)
        
        currentLocationButton.rx.tap
            .bind { [weak self] _ in
                guard let _ = LocationManager.shared.location else {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    return
                }
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: .init(
                    lat: LocationManager.shared.latitude,
                    lng: LocationManager.shared.longitude
                ), zoomTo: 14.0)
                
                self?.mapView.moveCamera(cameraUpdate)
            }.disposed(by: bag)
    }
    
    public override func setLayout() {
        view.addSubViews(mapView, searchBar, currentLocationButton)
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.top.equalTo(safeArea).inset(8)
            make.height.equalTo(56)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(safeArea).inset(20)
            make.width.height.equalTo(50)
        }
    }
    
}

extension LottyMapViewController: NMFMapViewCameraDelegate {
    
    public func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(mapView.cameraPosition.target)
    }
    
}
