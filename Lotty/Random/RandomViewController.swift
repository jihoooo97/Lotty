import UIKit

class RandomViewController: UIViewController {
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let emitterLayer = CAEmitterLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEmitterLayer()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
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
        cell.velocity = 200
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
    
    @IBAction func createNumber(_ sender: Any) {
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
        numberView.layer.addSublayer(emitterLayer)
    }
}

extension RandomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension RandomViewController: UITableViewDelegate {
    
}
