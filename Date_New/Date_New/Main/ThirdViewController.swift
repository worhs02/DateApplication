    //
    //  ThirdViewController.swift
    //  Date_New
    //
    //  Created by 이슬기 on 4/27/24.
    //

    import UIKit
    import MapKit

    class ThirdViewController: UIViewController {

        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .systemBackground
            
            // 맵뷰 생성
            let mapView = MKMapView(frame: self.view.bounds)
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // 초기 위치 설정 (선택 사항)
            let initialLocation = CLLocation(latitude: 37.5665, longitude: 126.9780) // 서울의 위도와 경도
            let regionRadius: CLLocationDistance = 10000 // 10km 반경
            let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            // 탭바의 높이 가져오기
            guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else {
                return
            }
               
            // 아래쪽 마진 설정
            mapView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarHeight)
            
            
            // 맵뷰를 뷰 계층에 추가
            self.view.addSubview(mapView)
        }

    }

