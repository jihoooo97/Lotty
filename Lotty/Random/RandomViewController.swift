import UIKit

class RandomViewController: UIViewController {
    @IBOutlet weak var backLabel1: BackgroundLabel!
    @IBOutlet weak var backLabel2: BackgroundLabel!
    @IBOutlet weak var backLabel3: BackgroundLabel!
    @IBOutlet weak var topLine: DottedLine!
    @IBOutlet weak var bottomLine: DottedLine!
    
    @IBOutlet weak var lotteryNumber: UILabel!
    @IBOutlet weak var getDay: UILabel!
    @IBOutlet weak var luckyDay: UILabel!
    @IBOutlet weak var endDay: UILabel!
    @IBOutlet weak var createButton: UIButton!
    
    let rightLine = RightLine()
    let AGame = GameView()
    let BGame = GameView()
    let CGame = GameView()
    let DGame = GameView()
    let EGame = GameView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(rightLine)
        rightLine.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightLine.frame.width + 10).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setCount(game: GameView, numberList: [Int]) {
        game.No1.configure(with: numberList[0])
        game.No2.configure(with: numberList[1])
        game.No3.configure(with: numberList[2])
        game.No4.configure(with: numberList[3])
        game.No5.configure(with: numberList[4])
        game.No6.configure(with: numberList[5])
        
        game.No1.animate()
        game.No2.animate()
        game.No3.animate()
        game.No4.animate()
        game.No5.animate()
        game.No6.animate()
    }
    
    func setView() {
        AGame.GameName.text = "A 게임"
        view.addSubview(AGame)
        AGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        AGame.topAnchor.constraint(equalTo: topLine.bottomAnchor, constant: 20).isActive = true
        AGame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        AGame.isHidden = true
        
        BGame.GameName.text = "B 게임"
        view.addSubview(BGame)
        BGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        BGame.topAnchor.constraint(equalTo: AGame.bottomAnchor, constant: 20).isActive = true
        BGame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        BGame.isHidden = true
        
        CGame.GameName.text = "C 게임"
        view.addSubview(CGame)
        CGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        CGame.topAnchor.constraint(equalTo: BGame.bottomAnchor, constant: 20).isActive = true
        CGame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        CGame.isHidden = true
        
        DGame.GameName.text = "D 게임"
        view.addSubview(DGame)
        DGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        DGame.topAnchor.constraint(equalTo: CGame.bottomAnchor, constant: 20).isActive = true
        DGame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        DGame.isHidden = true
        
        EGame.GameName.text = "E 게임"
        view.addSubview(EGame)
        EGame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        EGame.topAnchor.constraint(equalTo: DGame.bottomAnchor, constant: 20).isActive = true
        EGame.heightAnchor.constraint(equalToConstant: 20).isActive = true
        EGame.isHidden = true
        
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.white.cgColor
        createButton.layer.cornerRadius = 8
        createButton.layer.masksToBounds = false
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        createButton.layer.shadowOpacity = 0.2
    }
    
    func setNumber() -> [[Int]] {
        var randomList: [[Int]] = []
        for _ in 0...4 {
            var randomNo: [Int] = []
            for _ in 0..<6 {
                var drwtNo = Int.random(in: 1...45)
                while randomNo.contains(drwtNo) {
                    drwtNo = Int.random(in: 1...45)
                }
                randomNo.append(drwtNo)
            }
            randomNo.sort()
            randomList.append(randomNo)
        }
        return randomList
    }
    
    func setLineDot(view: UIView, color: String) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = UIColor(named: color)?.cgColor
        borderLayer.lineDashPattern = [12, 3]
        borderLayer.frame = view.bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(rect: view.bounds).cgPath
        view.layer.addSublayer(borderLayer)
    }
    
    
    @IBAction func createNumber(_ sender: Any) {
        AGame.isHidden = true
        BGame.isHidden = true
        CGame.isHidden = true
        DGame.isHidden = true
        EGame.isHidden = true
        
        let randomList = self.setNumber()
        
        let gameA = randomList[0]
        let gameB = randomList[1]
        let gameC = randomList[2]
        let gameD = randomList[3]
        let gameE = randomList[4]
        
        DispatchQueue.main.async {
            self.AGame.isHidden = false
            self.setCount(game: self.AGame, numberList: gameA)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.BGame.isHidden = false
                self.setCount(game: self.BGame, numberList: gameB)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.CGame.isHidden = false
                    self.setCount(game: self.CGame, numberList: gameC)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                        self.DGame.isHidden = false
                        self.setCount(game: self.DGame, numberList: gameD)
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                            self.EGame.isHidden = false
                            self.setCount(game: self.EGame, numberList: gameE)
                        }
                    }
                }
            }
            
        }
    }
}
