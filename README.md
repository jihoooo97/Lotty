![Swift 5.10](https://img.shields.io/badge/Swift-5.10-F05138.svg?style=flat&color=F05138) 
![Xcode 15.3](https://img.shields.io/badge/Xcode-15.3-147EFB.svg?style=flat&color=147EFB)
![iOS 15.0+](https://img.shields.io/badge/iOS-15.0+-147EFB.svg?style=flat&color=00E007)
![Tuist 4.18](https://img.shields.io/badge/Tuist-4.18-147EFB.svg?style=flat&color=6E12CB)

# 로또의민족 
> 로또 당첨 정보 조회, 주변 판매점 위치 확인, 번호 생성을 할 수 있는 서비스  
> [‎앱스토어](https://apps.apple.com/kr/app/로또의민족/id1615526962)
<img width="1164" alt="스크린샷 2023-03-03 오전 3 36 47" src="https://github.com/jihoooo97/Lotty/assets/49361214/c0c44a40-9fcd-45b2-b0ec-8238c3eaaa3f">  

<br><br>

## 개발 환경
| Framework | UIKit |
|:-:|:-|
| 구조 | MVVM + RxSwift + Clean Architecture |
| DI | Swinject |
| Network | Alamofire |
| Library | WebKit, NaverMaps, KakaoSDK, Kingfisher |
<br>

## 모듈 구조
![graph](https://github.com/jihoooo97/Lotty/assets/49361214/3bdf96ba-7947-408a-856c-1aaacddaade6)  

> **모듈화**
```
- 비슷한 책임을 갖는 코드(클래스, 패키지, 라이브러리 등)를 묶어 모듈로 나눠서 응집도를 향상시킴
- 모듈 간 의존 관계를 설정함으로써 알아야하는 대상과 알지 못해야하는 대상을 명확히 구분해줌으로 결합도를 낮추고 실수를 방지해 유지 보수가 용이함
- 만들어 놓은 모듈은 다른 프로젝트에서도 재사용할 수 있어 개발 효율이 높아짐
```

- **Lotty (App 모듈)**
  - AppDelegate, SceneDelegate, DI 주입, Resource(Info.plist, Font, Assets)
- **Data 모듈**
  - DTO, Network, Database, DataStoure, RepositoryImpl
- **Domain 모듈**
  - VO, UseCase, RepositoryProtocol
- **Presentation 모듈**
  - Feature, View, ViewModel
- **Common 모듈**
  - 공통 기능 (enum, extension, Helper 등)
- **CommonUI 모듈**
  - 공통 UI (UILabel, UIButtom, UITableView 등 Custom View, UI관련 extension)




<br>

## 아키텍처
<img width="800" alt="스크린샷 2024-07-08 오후 4 00 04" src="https://github.com/jihoooo97/Lotty/assets/49361214/6b3d4c51-1a36-4221-a9a7-392d71132949">

> **Clean Architecture** 
```
- 분리된 계층의 역할과 책임이 명확해져 코드 응집도가 높아지고, 테스트에 용이해짐
- 코드가 어떤 계층에 있을지 예측할 수 있어, 코드의 가독성과 개발 효율이 높아짐
```

- **Data Layer**: 서버 또는 로컬에서 직접적으로 데이터를 가져오거나 보내는 책임
- **Domain Layer**: 앱의 비즈니스 로직에 대한 책임
- **Presentation Layer**: UI 로직에 대한 책임

<br>

## 담당 역할
- 지도: 현 위치를 기반으로 주변 로또 판매점을 검색하여 NaverMap Marker로 표시하는 기능 개발
- 로또 회차 목록: 1,000여 개의 로또 회차에 대한 정보를 infinity scroll을 구현하여 조회할 수 있도록 개발
- QR Scan: AVKit의 AVCaptureDevice를 활용하여 QR Code Scan 기능 개발
- 로또번호 생성: 로또 번호를 중복되지 않게 랜덤으로 생성하는 로직 개발
<br>
