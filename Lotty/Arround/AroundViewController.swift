import UIKit
import CoreLocation
import NMapsMap

class AroundViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        configureMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // 판매점 이름 주소 전화번호
    func configureMap() {
        if CLLocationManager.locationServicesEnabled() {
            let naverMapView = NMFNaverMapView(frame: view.frame)
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - self.tabBarController!.tabBar.frame.size.height
            naverMapView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            view.addSubview(naverMapView)
            self.tabBarController?.tabBar.backgroundColor = .white
            naverMapView.mapView.positionMode = .direction
            
            // naverMapView.showLocationButton = true
            
            let latitude = locationManager.location?.coordinate.latitude ?? 37.3593486
            let longitude = locationManager.location?.coordinate.longitude ?? 127.104845
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
            cameraUpdate.reason = 3
            cameraUpdate.animation = .none
            cameraUpdate.animationDuration = 2
            naverMapView.mapView.moveCamera(cameraUpdate)
            
            configureDetail(map: naverMapView)
            
//            let marker = NMFMarker()
//            marker.position = NMGLatLng(lat: latitude, lng: longitude)
//            marker.mapView = naverMapView.mapView
        } else {
            // alert
            
        }
    }
    
    func configureDetail(map: NMFNaverMapView) {
        let detailView = StoreDetailView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        map.addSubview(detailView)
        detailView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
}
