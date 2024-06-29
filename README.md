![Swift 5.10](https://img.shields.io/badge/Swift-5.10-F05138.svg?style=flat&color=F05138) 
![Xcode 15.3](https://img.shields.io/badge/Xcode-15.3-147EFB.svg?style=flat&color=147EFB)
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-147EFB.svg?style=flat&color=00E007)
![Tuist 4.18](https://img.shields.io/badge/Tuist-4.18-147EFB.svg?style=flat&color=6E12CB)

# 로또의민족 
> 로또 당첨 정보 조회, 주변 판매점 위치 확인, 번호 생성을 할 수 있는 서비스  
> [‎앱스토어](https://apps.apple.com/kr/app/로또의민족/id1615526962)
<img width="1164" alt="스크린샷 2023-03-03 오전 3 36 47" src="https://github.com/jihoooo97/Lotty/assets/49361214/c0c44a40-9fcd-45b2-b0ec-8238c3eaaa3f">  

<br>

### 모듈 구조
![graph](https://github.com/jihoooo97/Lotty/assets/49361214/3bdf96ba-7947-408a-856c-1aaacddaade6)  

<br>

### 참여 인원
- iOS 1명, Android 1명
<br>

### 개발 환경 🛠️
| 버전 | iOS 15.0+ |
|:-:|:-:|
| Framework | UIKit |
| 구조 | MVVM + RxSwift + Clean Architecture |
| DI | Swinject |
| Network | Alamofire |
| Library | NaverMaps, KakaoSDK, Kingfisher |
<br>

### 담당 역할
- 지도: 현 위치를 기반으로 주변 로또 판매점을 검색하여 NaverMap Marker로 표시하는 기능 개발
- 로또 회차 목록: 1,000여 개의 로또 회차에 대한 정보를 infinity scroll을 구현하여 조회할 수 있도록 개발
- QR Scan: AVKit의 AVCaptureDevice를 활용하여 QR Code Scan 기능 개발
- 로또번호 생성: 로또 번호를 중복되지 않게 랜덤으로 생성하는 로직 개발
<br>

### 문제 경험
- 로또 회차 정보를 모두 보여주면 필요하지 않은 정보를 볼 수 있고, 화면에 보여줄 정보의 수도 적어져 비효율적인 상황이 발생  
-> UITableView의 section을 활용해 DropDown UI를 구현하여 필요한 회차 정보만 선택해서 펼쳐볼 수 있도록 구현하여 해결
<br>
