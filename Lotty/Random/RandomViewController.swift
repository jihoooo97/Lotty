import UIKit

class RandomViewController: UIViewController {
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var no1: CountLabel!
    @IBOutlet weak var no2: CountLabel!
    @IBOutlet weak var no3: CountLabel!
    @IBOutlet weak var no4: CountLabel!
    @IBOutlet weak var no5: CountLabel!
    @IBOutlet weak var no6: CountLabel!
    @IBOutlet weak var bonusNo: CountLabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let emitterLayer = CAEmitterLayer()
    var randomList: [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmitterLayer()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomList = Storage.retrive("random_list.json", from: .documents, as: [[Int]].self) ?? []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Storage.store(randomList, to: .documents, as: "random_list.json")
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
    
    func setNumber() {
        var randomNo: [Int] = []
        for _ in 0..<6 {
            var drwtNo = Int.random(in: 1...45)
            while randomNo.contains(drwtNo) {
                drwtNo = Int.random(in: 1...45)
            }
            randomNo.append(drwtNo)
        }
        randomNo.sort()
        var bonus = Int.random(in: 1...45)
        while randomNo.contains(bonus) {
            bonus = Int.random(in: 1...45)
        }
        randomNo.append(bonus)
        randomList.insert(randomNo, at: 0)
        tableView.reloadData()
        
        no1.configure(with: randomNo[0])
        no2.configure(with: randomNo[1])
        no3.configure(with: randomNo[2])
        no4.configure(with: randomNo[3])
        no5.configure(with: randomNo[4])
        no6.configure(with: randomNo[5])
        bonusNo.configure(with: randomNo[6])
    }
    
    private func setUpEmitterLayer() {
        emitterLayer.emitterCells = [emojiEmiterCell]
    }
    
    private var emojiEmiterCell: CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "coin_icon")!.cgImage
        
        //얼마나 유지될거냐 (number of seconds an object lives) 이거 짧게 주면 중간에 사라질수도
        cell.lifetime = 2
        //1초에 몇개 생성할거냐. (number of objects created per second)
        cell.birthRate = 20
        
        //크기
        cell.scale = 0.02
        //particle 마다 달라질 수 있는 scale 의 범위
        cell.scaleRange = 0
        
        //얼마나 빠른 속도로 회전할것인가. 0이면 회전 효과 없음
        cell.spin = 5
        //spin 범위
        cell.spinRange = 10
        
        // particle 이 방출되는 각도. 따라서 0 이면 linear 하게 방출됨.
        // 2pi = 360 도 = particle이 모든 방향으로 분산 됨.
        cell.emissionRange = CGFloat.pi * 2
        
        // 수치가 높을 수록 particle 이 빠르게, 더 멀리 방출되는 효과.
        // yAcceleration에 의해 영향 받음
        cell.velocity = 300
        //velocity 값의 범위를 뜻함.
        // 만약 기본 velocity가 700이고, velocityRange 가 50 이면,
        // 각 particle은 650-750 사이의 velocity 값을 갖게 됨
        cell.velocityRange = 50
        // gravity 효과.
        // 양수면 중력이 적용되는 것처럼 보이고, 음수면 중력이 없어져서 날아가는 것 처럼 보임.
        // velocity 와 yAcceleration의 조합이 distance 를 결정
        cell.yAcceleration = 200
        
        return cell
    }
    
    func coinEffect() {
        let x = numberView.center.x
        let y = numberView.bounds.height / 2
        
        //방출 point
        emitterLayer.emitterPosition = CGPoint(x: x, y: y)
        
        //cell 의 birth rate와 곱해져서 총 birth rate 가 정해짐
        emitterLayer.birthRate = 1
        
        //birthRate를 0을 설정해주지 않으면 시간동안 계속 cell을 방출함.
        // 한번 방출하고 끝내는것 처럼 보이게 엄청 짧게 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            //birth rate 가 0이 되면 더 이상 값을 방출하지 않는 것처럼 보임
            self?.emitterLayer.birthRate = 0
        }
        // 레이어 얹어주면 방출 시작되는 것 보임.
        // 신기한건 클릭할때마다 addSublayer가 불리니까 layer가 계속 쌓일거 같은데 count 로 찍어보면 계속 1임
        view.layer.addSublayer(emitterLayer)
    }
    
    @IBAction func createNumber(_ sender: Any) {
        DispatchQueue.main.async {
            self.setNumber()
            self.no1.animate()
            self.no2.animate()
            self.no3.animate()
            self.no4.animate()
            self.no5.animate()
            self.no6.animate()
            self.bonusNo.animate()
            self.coinEffect()
        }
    }
    
    @IBAction func clearNumber(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "번호 목록을 초기화 하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.randomList = []
            Storage.remove("random_list.json", from: .documents)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

extension RandomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "randomCell", for: indexPath) as? RandomCell else { return UITableViewCell() }
        
        let list = randomList[indexPath.row]
        cell.drwtNo1.text = "\(list[0])"
        cell.drwtNo2.text = "\(list[1])"
        cell.drwtNo3.text = "\(list[2])"
        cell.drwtNo4.text = "\(list[3])"
        cell.drwtNo5.text = "\(list[4])"
        cell.drwtNo6.text = "\(list[5])"
        cell.bnusNo.text = "\(list[6])"
        
        setRound(label: cell.drwtNo1)
        setRound(label: cell.drwtNo2)
        setRound(label: cell.drwtNo3)
        setRound(label: cell.drwtNo4)
        setRound(label: cell.drwtNo5)
        setRound(label: cell.drwtNo6)
        setRound(label: cell.bnusNo)
        
        cell.deleteButtonHandler = {
            self.randomList = self.randomList.filter({ $0 != self.randomList[indexPath.row] })
            self.tableView.reloadData()
        }
        return cell
    }
}

extension RandomViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 52
//    }
}
