import UIKit
import CoreLocation
import NMapsMap
import Alamofire

class AroundViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    let searchBar = SearchBarView()
    let detailView = StoreDetailView()
    let sideButton = SideButton()
    
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
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickMap))
            naverMapView.addGestureRecognizer(tapGesture)
            
            view.addSubview(naverMapView)
            self.tabBarController?.tabBar.backgroundColor = .white
            naverMapView.mapView.positionMode = .direction
            naverMapView.mapView.allowsTilting = false
            naverMapView.mapView.allowsRotating = false
            naverMapView.showZoomControls = false
            naverMapView.showScaleBar = false
            
            let latitude = locationManager.location?.coordinate.latitude ?? 37.3593486
            let longitude = locationManager.location?.coordinate.longitude ?? 127.104845
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
            cameraUpdate.animation = .none
            naverMapView.mapView.moveCamera(cameraUpdate)
            
            let paramerters: Parameters = [
                "x": longitude,
                "y": latitude,
                "query": "복권 판매점",
                "size": 15
            ]
            let headers: HTTPHeaders = [
                "Authorization": "KakaoAK 7165edf50ee98e1383adf5924f5a76ad"
            ]
            AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: paramerters, encoding: URLEncoding.queryString, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: StoreInfo.self) { response in
                switch response.result {
                case .success:
                    guard let stores = response.value?.documents else { return }
                    for store in stores {
                        let marker = NMFMarker()
                        marker.position = NMGLatLng(lat: Double(store.y)!, lng: Double(store.x)!)
                        marker.mapView = naverMapView.mapView
                        marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                            self.configureDetail(map: naverMapView, store: store)
                            return true
                        }
                    }
                    return
                case .failure:
                    return
                }
            }
            // camera 이동에 따라 판매점 갱신
            configureSearchBar(map: naverMapView)
            configureButton(map: naverMapView)
            
        } else {
            // alert
        }
    }
    
    func configureSearchBar(map: NMFNaverMapView) {
        searchBar.addTarget(self, action: #selector(clickSearch), for: .touchUpInside)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        map.addSubview(searchBar)
        searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
    }
    
    func configureDetail(map: NMFNaverMapView, store: Documents) {
        detailView.translatesAutoresizingMaskIntoConstraints = false
        detailView.storeName.text = store.place_name
        detailView.storeAddress.text = store.address_name
        detailView.storeCall.text = store.phone
        
        map.addSubview(detailView)
        detailView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    func configureButton(map: NMFNaverMapView) {
        sideButton.translatesAutoresizingMaskIntoConstraints = false
        
        map.addSubview(sideButton)
        sideButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sideButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sideButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4).isActive = true
        sideButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    @objc func clickSearch() {
        print("search!")
        // searchview 전환
    }
    
    @objc func clickMap(sender: UIGestureRecognizer) {
        let x = self.detailView.frame.minX
        let y = UIScreen.main.bounds.height + 100
        let width = self.detailView.frame.width
        let height = self.detailView.frame.height
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.detailView.frame = CGRect(x: x, y: y, width: width, height: height)
        })
    }
}

extension AroundViewController: NMFMapViewCameraDelegate {
    
}
