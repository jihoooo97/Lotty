import UIKit

class RandomViewController: UIViewController {
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
        rightLine.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightLine.frame.width / 2).isActive = true
        rightLine.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.backgroundColor = .white
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
        lotteryNumber.text = "제 \(getRecentNumber() + 1) 회"
        getDay.text = getNowTime()
        luckyDay.text = getNextDay(day: "next")
        endDay.text = getNextDay(day: "end")
        
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
        createButton.layer.cornerRadius = 4
        createButton.layer.masksToBounds = false
        createButton.layer.shadowColor = UIColor.black.cgColor
        createButton.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        createButton.layer.shadowOpacity = 0.4
        createButton.layer.shadowRadius = 1
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
    
    func getNowTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) kk:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let now = Date()
        return formatter.string(from: now)
    }
    
    func getRecentNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let base = 1002
        let origin = Date()
        let now = formatter.string(from: origin)
        
        guard let startTime = formatter.date(from: "2022-02-12 20:45:00") else { return 0 }
        guard let endTime = formatter.date(from: now) else { return 0 }
        
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        return base + count
    }
    
    func getNextDay(day: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        guard let start = formatter.date(from: "2022/03/05 (토) 20:45:00") else { return "error" }
        var addTime = Date()
        if day == "next" {
            addTime = start.addingTimeInterval(TimeInterval(86400 * 7 * (getRecentNumber() - 1004)))
        } else if day == "end" {
            addTime = start.addingTimeInterval(TimeInterval(86400 * 379))
        }
        return formatter.string(from: addTime)
    }
    
    @IBAction func createNumber(_ sender: Any) {
        getDay.text = getNowTime()
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
