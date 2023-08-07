# 로또의민족

- 주변 로또 판매점 조회, 로또 회차 조회, 로또 QR스캔 및 번호 생성이 가능한 로또 유틸리티 서비스
- 로또 판매점 검색과 당첨 번호 조회를 편하게 하기 위해 개발한 서비스  
<img width="1164" alt="스크린샷 2023-03-03 오전 3 36 47" src="https://github.com/jihoooo97/Lotty/assets/49361214/c0c44a40-9fcd-45b2-b0ec-8238c3eaaa3f">

<br><br>


👨‍👩‍👧‍👦  **구성원**
- iOS 1명 / AOS 1명

<br>

🛠️  **기술 스택**
- 구조: UIKit + MVVM-C + Clean Architecture
- 네트워크: Alamofire
- 비동기: RxSwift
- 라이브러리: KakaoSDK, NaverMaps

<br>

💪  **담당 역할**
- 로또의 민족 iOS 앱 개발 및 유지보수
    - **주변 로또 판매점:** NaverMap을 활용하여 로또 판매점 조회 및 검색 기능 개발
    - **로또 회차 정보:** 공공 API를 활용한 로또 당첨번호 조회 기능 개발 및 Section을 활용한 Drop-down UI 개발
    - **로또 QR스캔:** AVKit을 활용하여 로또 QR 스캔기능 개발
    - **로또번호 랜덤생성:** CAScrollLayer를 활용하여 로또 번호가 회전되는 시각적 재미요소 개발

<br>

**🤔 고민한 점**
- 사용자의 편의성을 고려한 UI/UX
- 확장성이 좋은 코드

<br>

**😮 배운 점**
- RxSwift를 통한 비동기처리
- MVVM 패턴의 적용으로 인한 View-ViewModel의 책임분리 학습
- SnapKit을 이용한 Code-Based UI
- NaverMaps 사용 경험

<br>

🥲 **아쉬운 점**
- 로또 회차를 1회씩만 제공해주는 API로 인한 효율적이지 않은 API 호출로 자체적인 API의 필요성을 느낌

<br>

🔗  **링크**  
- 앱스토어: [‎로또의민족](https://apps.apple.com/kr/app/로또의민족/id1615526962)

<br>
