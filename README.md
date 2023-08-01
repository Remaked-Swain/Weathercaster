#  Weather-Caster
OpenWeatherMap API를 이용해 날씨 정보 앱을 만들어보자

## OpenWeatherMap API
* 사용법
OpenWeatherMap API에서 날씨 정보에 대한 데이터를 얻을 수 있다.
![MakeAnAPICall](https://github.com/Remaked-Swain/ScreenShotRepository/blob/main/WeatherCaster/WeatherCaster_OpenWeatherMap_API_Call.png?raw=true)
(무료 요금제 기준에서) 날씨 정보의 기준이되는 경도, 위도 좌표와 API_Key를 매개변수로 GET요청을 보내면 JSON형식의 응답을 얻어낼 수 있다.
---------------------

## MapKit

#### To-Do
    * API_key 관리
1. OpenWeatherMap API - JSON Parsing, Modeling // Done
2. 기본적인 UI 구현 // Done
3. 경, 위도 좌표를 추출할 수 있는 방법 마련, MapKit 사용 // Done
4. 위치정보 허용받기 (plist) // Done
5. 지도 조작 후 DataService 연동하여 주소, 날씨 정보 업데이트하는 메서드 서로 연결하고 Combine 유지 // Done
6. 날씨 정보 UI 개선 // Done
7. FocusState 통해서 Keyboard dismiss function 구현 // Done
8. README.md 프로젝트 개발 일지 작성
