import UIKit
import Alamofire
import AVFoundation
import QRCodeReader

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var explainLabel: UILabel!
    private var refreshControl = UIRefreshControl()
    var lotteryArray: [LotteryItem] = []
    var searchHistoryList: [Int] = []
    var fetchingMore = false
    var recentNumber = 0
    var page = 0
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SearchLotteryViewController
        if segue.identifier == "detailLottery" {
            vc.lotteryInfo = sender as! LotteryInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        
        self.title = "조회하기"
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        self.navigationController?.navigationBar.layoutMargins.left = 32
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 글자 간격
        let attrString = NSMutableAttributedString(string: explainLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        explainLabel.attributedText = attrString
        
        recentNumber = getRecentNumber()
        for i in 0..<10 {
            getLotteryNumber(drwNo: recentNumber - i)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchHistoryList = Storage.retrive("search_history.json", from: .documents, as: [Int].self) ?? []
        print(searchHistoryList)
    }
    
    func getNowTime() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "ko-KR") as TimeZone?
        return formatter.string(from: now)
    }
    
    func getRecentNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let base = 1002
        let now = getNowTime()
        
        guard let startTime = formatter.date(from: "2022-02-12 20:34:00") else { return 0 }
        guard let endTime = formatter.date(from: now) else { return 0 }
        
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        
        return base + count
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    func getLotteryNumber(drwNo: Int) {
        let parameters: Parameters = [
            "method": "getLottoNumber",
            "drwNo": drwNo
        ]
        
        AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryInfo.self) { response in
            switch response.result {
            case .success:
                guard let lottery = response.value else { return }
                if lottery.drwNo == self.recentNumber {
                    self.lotteryArray.append(LotteryItem(lottery: lottery, open: true))
                } else {
                    self.lotteryArray.append(LotteryItem(lottery: lottery))
                }
                self.lotteryArray.sort(by: { $0.lottery.drwNo > $1.lottery.drwNo })
                self.tableView.reloadData()
                
            case .failure:
//                AF.request("https://www.dhlottery.co.kr/common.do", method: .get, parameters: parameters, encoding: URLEncoding.queryString).validate(statusCode: 200..<300).responseDecodable(of: LotteryFail.self) { response in
//                    switch response.result {
//                    case .success:
//                        guard let lottery = response.value else { return }
//                        print(lottery.returnValue)
//                        let item = LotteryInfo()
//                        self.lotteryArray.append(LotteryItem(lottery: LotteryInfo(), open: true))
//                    case .failure:
//                        return
//                    }
//                }
                return
            }
        }
    }
    
    // 퍼미션 인증 거부된 권한을 담는 배열
    var permissionNoArray : Array<String> = []
    
    // 카메라 권한 인증 확인 메소드
    /* [카메라 권한 요청]
     필요 : import AVFoundation */
    func checkCameraPermission() {
        print("[ViewController >> checkCameraPermission() :: 카메라 권한 요청 실시]")
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                print("[ViewController >> checkCameraPermission() :: 카메라 권한 허용 상태]")
            } else {
                print("[ViewController >> checkCameraPermission() :: 카메라 권한 거부 상태]")
                self.permissionNoArray.append("카메라")
            }
        })
    }
    
    // QR 객체 초기화 수행 실시
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // QR 스캔 뷰 컨트롤러 구성 실시
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = true // 화면 전환 버튼 표시 여부
            $0.showCancelButton       = true // 취소 버튼 표시 여부
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.3)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    // QR 코드 스캔 시작 실시
    func callQrScanStart(){
        print("[ViewController >> callQrScanStart() :: QR 스캔 시작 실시]")
        
        // [QR 패턴 사용 실시]
        self.readerVC.delegate = self
        // [클로저 사용 실시]
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("[ViewController >> callQrScanStart() :: QR 스캔 결과 확인 실시]")
            print("result : ", result?.value ?? "")
        }
        // [readerVC를 모달 양식 시트로 표시]
        self.readerVC.modalPresentationStyle = .fullScreen
        self.present(self.readerVC, animated: true, completion: nil)
    }
    // alert 팝업창 호출 메소드 정의 실시: 이벤트 호출 시
    // 호출 방법 : showAlert(tittle: "title", content: "content", okBtb: "확인", noBtn: "취소")
    func showAlert(tittle:String, content:String, okBtb:String, noBtn:String) {
        // [UIAlertController 객체 정의 실시]
        let alert = UIAlertController(title: tittle, message: content, preferredStyle: UIAlertController.Style.alert)
        // [인풋으로 들어온 확인 버튼이 nil 아닌 경우]
        if(okBtb != "" && okBtb.count > 0){
            let okAction = UIAlertAction(title: okBtb, style: .default) { action in
                return
            }
            alert.addAction(okAction)
        }
        // [인풋으로 들어온 취소 버튼이 nil 아닌 경우]
        if(noBtn != "" && noBtn.count > 0){
            let noAction = UIAlertAction(title: noBtn, style: .default) { action in
                return
            }
            alert.addAction(noAction)
        }
        // [alert 팝업창 활성 실시]
        present(alert, animated: false, completion: nil)
    }
    
    @IBAction func qrButton(_ sender: Any) {
        // [카메라 권한 부여 확인 실시]
        print("[ViewController >> viewDidLoad() :: 액티비티 메모리 로드 실시]")
        self.checkCameraPermission()
        print("[ViewController >> viewDidAppear() :: 뷰 화면 표시]")
        
        // [권한 설정 퍼미션 확인 실시]
        if permissionNoArray.count > 0 && permissionNoArray.isEmpty == false {
            showAlert(tittle: "[알림]", content: "카메라 권한이 비활성 상태입니다.", okBtb: "확인", noBtn: "")
            permissionNoArray.removeAll()
        } else {
            // [권한 허용 상태]
            // [QR 스캔 시작 메소드 호출 실시]
            self.callQrScanStart()
        }
    }
}

// MARK: 테이블뷰 DataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return lotteryArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lotteryArray[section].open == true { return 2 }
        else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCloseCell", for: indexPath) as? NumberCloseCell else { return UITableViewCell() }
            if lotteryArray[indexPath.section].open == true {
                cell.status.image = UIImage(named: "arrow_up_icon")
            } else {
                cell.status.image = UIImage(named: "arrow_down_icon")
            }
            cell.drwNo.text = "\(lotteryArray[indexPath.section].lottery.drwNo)회"
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath) as? NumberCell else { return UITableViewCell() }
            cell.date.text = lotteryArray[indexPath.section].lottery.drwNoDate
            cell.no1.text = "\(lotteryArray[indexPath.section].lottery.drwtNo1)"
            cell.no2.text = "\(lotteryArray[indexPath.section].lottery.drwtNo2)"
            cell.no3.text = "\(lotteryArray[indexPath.section].lottery.drwtNo3)"
            cell.no4.text = "\(lotteryArray[indexPath.section].lottery.drwtNo4)"
            cell.no5.text = "\(lotteryArray[indexPath.section].lottery.drwtNo5)"
            cell.no6.text = "\(lotteryArray[indexPath.section].lottery.drwtNo6)"
            cell.bonusNo.text = "\(lotteryArray[indexPath.section].lottery.bnusNo)"
            cell.winCount.text = "총 \(lotteryArray[indexPath.section].lottery.firstPrzwnerCo)명 당첨"
            cell.winAmount.text = numberFormatter(number: lotteryArray[indexPath.section].lottery.firstWinamnt)
            cell.detailButtonHandler = {
                self.searchHistoryList = self.searchHistoryList.filter { $0 != self.lotteryArray[indexPath.section].lottery.drwNo }
                self.searchHistoryList.insert(self.lotteryArray[indexPath.section].lottery.drwNo, at: 0)
                Storage.store(self.searchHistoryList, to: .documents, as: "search_history.json")
                self.performSegue(withIdentifier: "detailLottery", sender: self.lotteryArray[indexPath.section].lottery)
            }
            setRound(label: cell.no1)
            setRound(label: cell.no2)
            setRound(label: cell.no3)
            setRound(label: cell.no4)
            setRound(label: cell.no5)
            setRound(label: cell.no6)
            setRound(label: cell.bonusNo)
            return cell
        }
    }
    
    func setRound(label: UILabel) {
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 18
        if Int(label.text!)! <= 10 {
            label.backgroundColor = .firstColor
        } else if Int(label.text!)! <= 20 {
            label.backgroundColor = .secondColor
        } else if Int(label.text!)! <= 30 {
            label.backgroundColor = .thirdColor
        } else if Int(label.text!)! <= 40 {
            label.backgroundColor = .fourthColor
        } else {
            label.backgroundColor = .fifthColor
        }
    }
}

// MARK: 테이블뷰 Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 50 }
        else { return 200 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NumberCloseCell else { return }
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == indexPath.row && index.row == 0 {
            if lotteryArray[indexPath.section].open == true {
                lotteryArray[indexPath.section].open = false
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            } else {
                lotteryArray[indexPath.section].open = true
                let section = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(section, with: .fade)
            }
        }
        
    }
}

// MARK: 테이블뷰 갱신
extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset_y = tableView.contentOffset.y
        let tableViewContentSize = tableView.contentSize.height
        let pagination_y = tableView.bounds.size.height
        
        if contentOffset_y > (tableViewContentSize - pagination_y) {
            if !fetchingMore {
                beingFetch()
            }
        }
    }
    
    // MARK: 최신회차
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            self.lotteryArray = []
            self.page = 0
            recentNumber = getRecentNumber()
            print(recentNumber)
            for i in 0..<10 { getLotteryNumber(drwNo: recentNumber - i) }
            self.tableView.reloadData()
        }
    }
    
    private func beingFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.page += 1
            if self.recentNumber - (self.page * 10) > 10 {
                for i in 0..<10 { self.getLotteryNumber(drwNo: self.recentNumber - (self.page * 10 + i)) }
                self.fetchingMore = false
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchViewController: QRCodeReaderViewControllerDelegate {
    // QRCodeReaderViewController 대리자 메소드
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("[ViewController >> reader() :: QR 스캔 종료 실시]")
        reader.stopScanning() // 스캔 중지
        self.dismiss(animated: true, completion: nil) // 카메라 팝업창 없앰
    }
    
    // 카메라 전환 버튼 이벤트 확인
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = String(newCaptureDevice.device.localizedName)
        print("[ViewController >> reader() :: 카메라 전환 버튼 이벤트 확인]")
        print("cameraName : ", cameraName)
    }
    
    // QR 스캔 종료 실시
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        print("[ViewController >> readerDidCancel() :: QR 스캔 취소 실시]")
        reader.stopScanning() // 스캔 중지
        self.dismiss(animated: true, completion: nil) // 카메라 팝업창 없앰
    }
}
