import UIKit

class RandomViewController: UIViewController {
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let testLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: 30)
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        label.text = "로또의 민족                              로또의 민족                              로또의 민족                              로또의 민족                         로또의 민족          "
        
        label.textColor = .white
        label.backgroundColor = .B600
        label.alpha = 0.5
        return label
    }()
    
    var randomList: [[Int]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(testLabel)
        testLabel.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -testLabel.frame.width + 10).isActive = true
        testLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        randomList = Storage.retrive("random_list.json", from: .documents, as: [[Int]].self) ?? []
        self.tabBarController?.tabBar.backgroundColor = .white
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
    }
    
    @IBAction func createNumber(_ sender: Any) {
        DispatchQueue.main.async {
//            self.setNumber()
        }
    }
    
    @IBAction func clearNumber(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "번호 목록을 초기화 하시겠습니까?", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            self.randomList = []
            Storage.remove("random_list.json", from: .documents)
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
