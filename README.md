#  Weather-Caster
OpenWeatherMap API를 이용해 날씨 정보 앱을 만들어보자

## OpenWeatherMap API
* 사용법
OpenWeatherMap API에서 날씨 정보에 대한 데이터를 얻을 수 있다.

![MakeAnAPICall](https://github.com/Remaked-Swain/ScreenShotRepository/blob/main/WeatherCaster/WeatherCaster_OpenWeatherMap_API_Call.png?raw=true)

> (무료 요금제 기준에서) 날씨 정보의 기준이되는 경도, 위도 좌표와 API_Key를 매개변수로 GET요청을 보내면 JSON형식의 응답을 얻어낼 수 있다.

* JSON 응답을 파싱하여 Swift에서 날씨 정보로 모델링
```Swift
struct WeatherModel: Codable {
    let coord: Coord? // 좌표
    let weather: [Weather]? // [기상상태 id, 대표설명, 부가설명, 아이콘]
    let base: String? // 기상 데이터의 출처
    let main: Main? // 평균기온, 체감온도, 최저온도, 최대온도, 기압, 습도
    let visibility: Int? // 가시성(미터 단위)
    let wind: Wind? // 풍속, 풍향
    let clouds: Clouds? // 전체 구름 양을 백분율로 나타냄
    let dt: Int? // 기상 정보가 제공된 시간 (타임스탬프)
    let sys: Sys? // 일출시각, 일몰시각, 국가코드(두 글자 알파벳)
    let timezone, id: Int? // UTC와의 시간차, 지역 id
    let name: String? // 지명
    let cod: Int? // 서버 응답 코드 -> 따로 활용할 일 없음
}
    ...생략...
```
> base, cod 같은 경우는 무엇을 의미하는지 몰라서 해당 API 의 문서를 보았더니 내부 매개변수라고 한다.
---------------------

## MapKit
OpenWeatherMap API 로 지역좌표를 전달하려면 어떻게 해야할까?
Kakao Local API가 먼저 떠올랐지만, 마침 이 날씨 앱의 메인화면을 구상하던 중 백그라운드로 지도를 넣어두면 어떨까싶어 겸사겸사 MapKit을 사용하기로 했다.

```Swift
import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    
    private let locationManager = CLLocationManager()
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }
}
```
    1. LocationManager라는 이름의 위치관리자를 만든다. CLLocationManagerDelegate 프로토콜을 통해 위치센서에 접근할 권한을 위임받는다.
    2. Info.plist에서 앱 사용 중 위치 정보 접근에 대한 적절한 권한을 취득한다.
    3. @MainActor 래퍼를 붙혀두면 메인쓰레드에서의 작업을 보장받을 수 있게 되어 멀티쓰레딩 환경에서 작업 충돌 등의 문제를 예방하는 효과가 있다고 한다.
---------------------

## WeatherDataService & NetworkingManager
URL로 요청을 한 모듈에서 관리할 수 있도록 하기 위해 만든 NetworkingManager와 OpenWeatherMap API와 통신을 수행할 WeatherDataService 클래스의 도움을 받아 날씨 데이터를 관리한다.

```Swift
import Foundation
import CoreLocation
import Combine
import SwiftUI

class WeatherDataService {
    @Published var weather: WeatherModel? = nil
    @Published var image: UIImage? = nil
    
    private var weatherSubscription: AnyCancellable?
    private var imageSubscription: AnyCancellable?
    
    private let openKey: String = "OPENWEATHERMAP_KEY"
    
    init(coordinates: CLLocationCoordinate2D) {
        loadData(coordinates)
    }
    
    func loadData(_ coordinates: CLLocationCoordinate2D) {
        // Read Bundle to get apiKey
        guard let apiKey: String = Bundle.getAPIKey(for: openKey) else { return }
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=metric&lang=kr") else { print("유효하지 않은 URL"); return }
        
        print("URL: \(url.description) 날씨 정보 요청")
        
        weatherSubscription = NetworkingManager.download(url: url)
        // Converting to WeatherModel
            .decode(type: WeatherModel.self, decoder: JSONDecoder())
        // WeatherModel 수신 후 구독 취소
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] receivedWeatherModel in
                    self?.weather = receivedWeatherModel
                    self?.weatherSubscription?.cancel()
                    self?.getWeatherImage(receivedWeatherModel)
            })
    }
    
    private func getWeatherImage(_ weather: WeatherModel) {
        guard let iconCode = weather.weather?.first?.icon
        else { print("IconCode를 확인할 수 없음."); return }
        
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png") else { print("유효하지 않은 URL."); return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(
                receiveCompletion: NetworkingManager.handleCompletion,
                receiveValue: { [weak self] receivedImage in
                    self?.image = receivedImage
                    self?.imageSubscription?.cancel()
                })
    }
}

extension Bundle {
    static func getAPIKey(for openKey: String) -> String? {
        guard
            let url = Bundle.main.url(forResource: "ApiKeys", withExtension: "plist"),
            let data = try? Data(contentsOf: url)
        else { print("Bundle 에서 ApiKeys.plist 를 찾을 수 없습니다."); return nil }
        
        do {
            if
                let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String:String],
                let apiKey = dict[openKey] {
                return apiKey
            } else {
                print("ApiKeys[\(openKey)] 값을 찾을 수 없습니다."); return nil
            }
        } catch {
            print("ApiKeys 를 읽는 중 문제가 발생했습니다. \(error)")
            return nil
        }
    }
}
```
    1. API요청을 위한 API_Key는 악의적인 사용을 방지하기 위해 보안에 신경써야한다. 나는 API_Key를 하드코딩하지 않고 Property List 파일을 만들어 보관한 뒤 필요할 때 plist파일을 읽어서 값을 갖다 쓸 수 있도록 하기 위해 Bundle에 대한 extension 으로 위와 같은 함수를 사용했다. PropertyList 파일을 딕셔너리 타입으로 바꿔서 값을 읽고... 이런 과정이 처음에는 쉽게 이해되지 않아서 곳곳에 print문을 깔아두고 어디서 문제가 발생하는지 추적해가며 테스트했다.
    2. 받아온 API 응답을 정의되어있는 Weather모델로의 디코딩한 뒤 각각 필요한 프로퍼티에 sink 하는 역할을 수행하는 모듈이다.
    3. 특히 Combine을 사용한 URLSession 응답 처리를 연습하고 싶어서 알고 있는 지식대로 코드를 작성해보았으나, weatherSubscription과 imageSubscription 을 변환하는 부분은 더 명확하게 바꿀 수 있을 것 같은데 잘 모르겠다...
---------------------

## MainViewModel
```Swift
import Foundation
import MapKit
import Combine

@MainActor
class MainViewModel: ObservableObject {
    // map
    @Published var region = MKCoordinateRegion()
    
    // weather
    @Published var weather: WeatherModel? = nil
    @Published var showFullWeatherInfo: Bool = false
    
    // weather image
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    // Search by address or placemark name
    @Published var searchResults: [PlaceModel] = []
    @Published var textFieldText: String = ""
    
    // Services
    private let weatherDataService = WeatherDataService(coordinates: LocationManager.shared.region.center)
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        moveCameraOnLocation(to: nil)
        addSubscribers()
    }
    
    func addSubscribers() {
        // textFieldText의 변화가 있으면 0.5초 유예한 후 중복 요청을 제거, 마지막 검색 응답만 수신
        $textFieldText
            .filter { $0.isEmpty == false }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.searchAddress(text: searchText, region: LocationManager.shared.region)
            }
            .store(in: &cancellables)
        
        // weatherDataService 에서 유지하는 weather 에 변화가 감지되면 mainVM 의 weather 도 업데이트
        weatherDataService.$weather
            .sink { [weak self] receiveWeatherModel in
                self?.weather = receiveWeatherModel
            }
            .store(in: &cancellables)
        
        // WeatherDataService 에서 유지하는 image 에 변화가 감지되면 mainVM 의 image 도 업데이트
        weatherDataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] receivedImage in
                self?.image = receivedImage
            }
            .store(in: &cancellables)
    }
}

// MARK: LocationManager Methods
extension MainViewModel {
    private func searchAddress(text: String, region: MKCoordinateRegion) {
        // 검색 조건 설정
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = region
        
        // 검색 수행 객체 생성
        let search = MKLocalSearch(request: request)
        
        // 검색 수행하고 MapKit에서 응답받은 결과물을 저장
        search.start { response, error in
            guard let response = response else { print("검색 실패. \(error?.localizedDescription ?? "Unknown Error")"); return }
            self.searchResults = response.mapItems.map(PlaceModel.init)
        }
    }
    
    // 카메라를 특정 좌표로 이동하거나 nil이 들어오면 현재 사용자 위치로 이동, 바뀐 좌표의 날씨 정보로 업데이트
    func moveCameraOnLocation(to place: PlaceModel?) {
        guard let place = place else {
            self.region = LocationManager.shared.region
            fetchWeatherDataByPlace(coordinates: LocationManager.shared.region.center)
            return
        }
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        fetchWeatherDataByPlace(coordinates: place.coordinates)
    }
}

// MARK: OpenWeatherMap API Methods
extension MainViewModel {
    private func fetchWeatherDataByPlace(coordinates: CLLocationCoordinate2D) {
        weatherDataService.loadData(coordinates)
    }
}
```
* 기능
    1. 주소, 도로명, 건물명으로 검색하여 MapKit에서 검색결과을 받을 수 있다.
    2. 검색결과 중 선택하면 지도가 해당 위치로 이동해 마커를 찍어준다.
    3. 또한 언제든 현재 사용자의 위치로 돌아올 수 있다.
    4. 2번과 3번 기능을 통해서 지도가 보여주는 위치를 변경하면 해당 지역의 좌표를 사용해 날씨 정보를 불러올 수 있다.
---------------------

#### To-Do
    * API_key 관리 방안 마련 // Done
1. OpenWeatherMap API - JSON Parsing, Modeling // Done
2. 기본적인 UI 구상 // Done
3. 경, 위도 좌표를 추출할 수 있는 방법 마련 -> MapKit 사용 // Done
4. 위치정보 허용받기 (plist) // Done
5. 지도 조작 후 DataService 연동하여 주소, 날씨 정보 업데이트하는 메서드 서로 연결하고 Combine 유지 // Done
6. 날씨 정보 UI 개선 // Done
7. FocusState 통해서 Keyboard dismiss function 구현 // Done
8. README.md 프로젝트 개발 일지 작성
