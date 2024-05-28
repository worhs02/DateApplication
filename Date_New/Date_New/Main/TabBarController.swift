////
////  TabBarController.swift
////  Date_New
////
////  Created by 송재곤 on 5/29/24.
////
//
//import UIKit
//
//class TabBarController: UITabBarController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Create UITabBarController
//        let tabBarController = UITabBarController()
//        
//        // Create and configure view controllers
//        let homeVC = FirstViewController()
//        if let resizedHomeImage = UIImage(named: "home")?.resized(toWidth: 30) {
//            homeVC.tabBarItem = UITabBarItem(title: "홈", image: resizedHomeImage.withRenderingMode(.alwaysOriginal), tag: 0)
//        }
//        //homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
//        
//        let categoryVC = SecondViewController()
//        if let resizedCategoryImage = UIImage(named: "category")?.resized(toWidth: 30) {
//            categoryVC.tabBarItem = UITabBarItem(title: "카테고리", image: resizedCategoryImage.withRenderingMode(.alwaysOriginal), tag: 1)
//        }
//        //categoryVC.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 1)
//        
//        let mapVC = ThirdViewController()
//        if let resizedMapImage = UIImage(named: "map")?.resized(toWidth: 30) {
//            mapVC.tabBarItem = UITabBarItem(title: "지도", image: resizedMapImage.withRenderingMode(.alwaysOriginal), tag: 2)
//        }
//        //mapVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "korea"), tag: 2)
//        
//        let calendarVC = FourthViewController()
//        if let resizedCalendarImage = UIImage(named: "calendar")?.resized(toWidth: 30) {
//            calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: resizedCalendarImage.withRenderingMode(.alwaysOriginal), tag: 3)
//        }
//        //calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 3)
//        
//        let myPlacesVC = FifthViewController()
//        if let resizedPlaceImage = UIImage(named: "place")?.resized(toWidth: 30) {
//            myPlacesVC.tabBarItem = UITabBarItem(title: "내 장소", image: resizedPlaceImage.withRenderingMode(.alwaysOriginal), tag: 4)
//        }
//        //myPlacesVC.tabBarItem = UITabBarItem(title: "내 장소", image: UIImage(systemName: "square.and.arrow.down.fill"), tag: 4)
//        
//        // Add view controllers to the tab bar controller
//        tabBarController.viewControllers = [homeVC, categoryVC, mapVC, calendarVC, myPlacesVC]
//        
//        tabBarController.tabBar.barTintColor = .white
//        tabBarController.tabBar.layer.borderWidth = 1
//        tabBarController.tabBar.layer.borderColor = UIColor.lightGray.cgColor
//    }
//}
//extension UIImage {
//    func resized(toWidth width: CGFloat, isOpaque: Bool = false) -> UIImage? {
//        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
//        let format = UIGraphicsImageRendererFormat.default()
//        format.opaque = isOpaque
//        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
//        let resizedImage = renderer.image { (context) in
//            self.draw(in: CGRect(origin: .zero, size: canvasSize))
//        }
//        return resizedImage
//    }
//}
