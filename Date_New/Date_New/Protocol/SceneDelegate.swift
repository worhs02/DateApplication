//
//  SceneDelegate.swift
//  Date_New
//
//  Created by 이슬기 on 4/27/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create UITabBarController
        let tabBarController = UITabBarController()
        
        // Create and configure view controllers
        let homeVC = FirstViewController()
        if let resizedHomeImage = UIImage(named: "home")?.resized(toWidth: 30) {
            homeVC.tabBarItem = UITabBarItem(title: "홈", image: resizedHomeImage.withRenderingMode(.alwaysOriginal), tag: 0)
        }
        //homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        
        let categoryVC = SecondViewController()
        if let resizedCategoryImage = UIImage(named: "category")?.resized(toWidth: 30) {
            categoryVC.tabBarItem = UITabBarItem(title: "카테고리", image: resizedCategoryImage.withRenderingMode(.alwaysOriginal), tag: 1)
        }
        //categoryVC.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(systemName: "square.grid.2x2.fill"), tag: 1)

        let mapVC = ThirdViewController()
        if let resizedMapImage = UIImage(named: "map")?.resized(toWidth: 30) {
            mapVC.tabBarItem = UITabBarItem(title: "지도", image: resizedMapImage.withRenderingMode(.alwaysOriginal), tag: 2)
        }
        //mapVC.tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "korea"), tag: 2)
        
        let calendarVC = FourthViewController()
        if let resizedCalendarImage = UIImage(named: "calendar")?.resized(toWidth: 30) {
            calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: resizedCalendarImage.withRenderingMode(.alwaysOriginal), tag: 3)
        }
        //calendarVC.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 3)
        
        let myPlacesVC = FifthViewController()
        if let resizedPlaceImage = UIImage(named: "place")?.resized(toWidth: 30) {
            myPlacesVC.tabBarItem = UITabBarItem(title: "내 장소", image: resizedPlaceImage.withRenderingMode(.alwaysOriginal), tag: 4)
        }
        //myPlacesVC.tabBarItem = UITabBarItem(title: "내 장소", image: UIImage(systemName: "square.and.arrow.down.fill"), tag: 4)
        
        // Add view controllers to the tab bar controller
        tabBarController.viewControllers = [homeVC, categoryVC, mapVC, calendarVC, myPlacesVC]
        
        // Create UIWindow and set rootViewController
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension UIImage {
    func resized(toWidth width: CGFloat, isOpaque: Bool = false) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = UIGraphicsImageRendererFormat.default()
        format.opaque = isOpaque
        let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
        let resizedImage = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: canvasSize))
        }
        return resizedImage
    }
}
