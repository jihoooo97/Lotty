import UIKit
import CoreLocation
import NMapsMap
import Alamofire
import Network

protocol SearchDelegate: AnyObject { func mapSearch(query: String) }

class AroundViewController: UIViewController, CLLocationManagerDelegate {
    let monitor = NWPathMonitor()
    var locationManager = CLLocationManager()
    let naverMapView = NMFNaverMapView()
    let searchBar = SearchBarView()
    let detailView = StoreDetailView()
    let sideButton = SideButton()
    let blockView = UIView()
    let alertView = AlertView()
    
    var markerList: [LotteryMarker] = []
    
    var fourClover = UIImage()
    var threeClover = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // network 연결상태 확인
        monitor.start(queue: DispatchQueue.global())
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        naverMapView.mapView.touchDelegate = self
        
        configureMap()
        if CLLocationManager.locationServicesEnabled() {
            let latitude = locationManager.location?.coordinate.latitude ?? 37.3593486
            let longitude = locationManager.location?.coordinate.longitude ?? 127.104845
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
            cameraUpdate.animation = .easeOut
            naverMapView.mapView.moveCamera(cameraUpdate)
        }
            self.configureAlertView()
            let x = self.alertView.frame.minX
            let y = UIScreen.main.bounds.height - 260
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                UIView.animate(withDuration: 1,
                               animations: {
                    self.alertView.frame.origin = CGPoint(x: x, y: y)
                })
            }
    }
    
    func configureMap() {
        fourClover = resizeImage(image: UIImage(named: "clover_four_icon")!, width: 50, height: 53)
        threeClover = resizeImage(image: UIImage(named: "clover_three_icon")!, width: 50, height: 50)
        
        if CLLocationManager.locationServicesEnabled() {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height - self.tabBarController!.tabBar.frame.size.height
            naverMapView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            view.addSubview(naverMapView)
            self.tabBarController?.tabBar.backgroundColor = .white
            naverMapView.mapView.addCameraDelegate(delegate: self)
            naverMapView.mapView.positionMode = .direction
            naverMapView.mapView.allowsTilting = false
            naverMapView.mapView.allowsRotating = false
            naverMapView.showScaleBar = false
            
            configureNavi()
            configureButton()
        } else {
            // 권한 허용 alert
        }
    }
    
    func configureNavi() {
        view.addSubview(searchBar)
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4).isActive = true
        
        searchBar.addTarget(self, action: #selector(clickSearch), for: .touchUpInside)
    }
    
    @objc func clickSearch() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "searchMap") as? MapSearchViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    func configureDetail(store: Documents) {
        detailView.id = store.id
        detailView.lat = store.y
        detailView.lng = store.x
        
        detailView.storeName.text = store.place_name
        detailView.storeAddress.text = store.address_name
        detailView.storeCall.text = store.phone
        
        view.addSubview(detailView)
        detailView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        
        let naviTap = UITapGestureRecognizer(target: self, action: #selector(clickNavi))
        detailView.naviView.addGestureRecognizer(naviTap)
    }
    
    @objc func clickNavi() {
        let x = locationManager.location?.coordinate.longitude ?? 127.104845
        let y = locationManager.location?.coordinate.latitude ?? 37.3593486
        let url = "kakaomap://route?" + "ep=\(y),\(x)" + "&ep=\(detailView.lat),\(detailView.lng)" + "&by=CAR"
        
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp)
        } else {
            let downApp = URL(string: "https://apps.apple.com/us/app/id304608425")!
            UIApplication.shared.open(downApp)
        }
    }
    
    func configureButton() {
        view.addSubview(sideButton)
        sideButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sideButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sideButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12).isActive = true
        sideButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        
        let locationTap = UITapGestureRecognizer(target: self, action: #selector(clickLocationButton))
        sideButton.currentLocationButton.addGestureRecognizer(locationTap)
    }
    
    @objc func clickLocationButton() {
        let latitude = locationManager.location?.coordinate.latitude ?? 37.3593486
        let longitude = locationManager.location?.coordinate.longitude ?? 127.104845
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude))
        cameraUpdate.animation = .easeIn
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    func configureAlertView() {
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.backgroundColor = .black
        blockView.alpha = 0.6
        
        view.addSubview(blockView)
        blockView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blockView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blockView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blockView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        view.addSubview(alertView)
        alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        alertView.confirmButton.addTarget(self, action: #selector(popAlert), for: .touchUpInside)
    }
    
    @objc func popAlert() {
        self.alertView.confirmButton.isEnabled = false
        DispatchQueue.main.async {
            self.alertView.removeFromSuperview()
            self.blockView.removeFromSuperview()
        }
        let url = "kakaomap://"
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp)
        } else {
            let downApp = URL(string: "https://apps.apple.com/us/app/id304608425")!
            UIApplication.shared.open(downApp)
        }
    }
    
    func resizeImage(image: UIImage, width: CGFloat, height: CGFloat) -> UIImage {
         UIGraphicsBeginImageContext(CGSize(width: width, height: height))
         image.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
         let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return newImage!
     }
    
    // map 클릭 시 마커 이미지 변경
    @objc func clickMap() {
        let x = self.detailView.frame.minX
        let y = UIScreen.main.bounds.height + 100

        UIView.animate(withDuration: 0.5,
                       animations: {
            self.detailView.frame.origin = CGPoint(x: x, y: y)
            self.detailView.id = "-"
        })

        for marker in self.markerList {
            if marker.storeId != self.detailView.id {
                marker.marker.iconImage = NMFOverlayImage(image: self.threeClover)
            }
        }
    }
}

// MARK: CAMERA별 판매점 마커 갱신
extension AroundViewController: NMFMapViewCameraDelegate {
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        for marker in markerList {
            if marker.storeId != self.detailView.id {
                self.markerList = self.markerList.filter({$0.marker != marker.marker})
                marker.marker.mapView = nil
            }
        }
        
        let positon = mapView.cameraPosition.target
        let paramerters: Parameters = [
            "x": positon.lng,
            "y": positon.lat,
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
                for i in 0..<stores.count {
                    let marker = LotteryMarker(marker: NMFMarker(), storeId: stores[i].id)
                    marker.marker.position = NMGLatLng(lat: Double(stores[i].y)!, lng: Double(stores[i].x)!)
                    if !self.markerList.contains(where: {$0.storeId == marker.storeId}) && marker.storeId != self.detailView.id {
                        self.markerList.append(marker)
                        marker.marker.mapView = self.naverMapView.mapView
                    }
                    
                    if stores[i].id == self.detailView.id {
                        marker.marker.iconImage = NMFOverlayImage(image: self.fourClover)
                    } else {
                        marker.marker.iconImage = NMFOverlayImage(image: self.threeClover)
                    }
                    
                    marker.marker.touchHandler = { (overlay: NMFOverlay) -> Bool in
                        self.configureDetail(store: stores[i])
                        let x = self.detailView.frame.minX
                        let y = UIScreen.main.bounds.height - 8
                        self.detailView.frame.origin = CGPoint(x: x, y: y + 198)
                        UIView.animate(withDuration: 0.5,
                                       animations: {
                            self.detailView.frame.origin = CGPoint(x: x, y: y)
                        })
                        
                        marker.marker.iconImage = NMFOverlayImage(image: self.fourClover)
                        for marker in self.markerList.filter({ $0.marker != marker.marker }) {
                            marker.marker.iconImage = NMFOverlayImage(image: self.threeClover)
                        }
                        return true
                    }
                }
            case .failure:
                self.monitor.pathUpdateHandler = { [weak self] path in
                    // 검색 한도 초과 시
                    if path.status == .satisfied {
                        self!.configureAlertView()
                        let x = self!.alertView.frame.minX
                        let y = UIScreen.main.bounds.height - 260
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                            UIView.animate(withDuration: 1,
                                           animations: {
                                self!.alertView.frame.origin = CGPoint(x: x, y: y)
                            })
                        }
                    }
                }
            }
        }
    }
}

extension AroundViewController: NMFMapViewTouchDelegate {
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        clickMap()
    }
}

// MARK: 지도 검색 결과
extension AroundViewController: SearchDelegate {
    func mapSearch(query: String) {
        let paramerters: Parameters = [
            "query": query,
            "size": 1
        ]
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 7165edf50ee98e1383adf5924f5a76ad"
        ]
        AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: paramerters, encoding: URLEncoding.queryString, headers: headers).validate(statusCode: 200..<300).responseDecodable(of: StoreInfo.self) { response in
            switch response.result {
            case .success:
                guard let result = response.value?.documents else { return }
                guard let coord = result.first else { return }
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: Double(coord.y)!, lng: Double(coord.x)!))
                self.naverMapView.mapView.moveCamera(cameraUpdate)
            case .failure:
                return
            }
        }
    }
}

struct LotteryMarker {
    var marker: NMFMarker
    var storeId: String
}
